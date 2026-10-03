import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import mysql from "mysql2/promise";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

const pool = mysql.createPool({
  host: process.env.DB_HOST || "localhost",
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "",
  database: process.env.DB_NAME || "ecommerce_analytics",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

async function query(sql, params = []) {
  const [rows] = await pool.query(sql, params);
  return rows;
}

app.get("/api/health", async (_req, res) => {
  try {
    await query("SELECT 1 AS ok");
    res.json({ success: true, database: process.env.DB_NAME || "ecommerce_analytics" });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "MySQL connection failed",
      error: error.message
    });
  }
});

app.get("/api/overview", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT
        ROUND(COALESCE(SUM(
          CASE WHEN o.status = 'DELIVERED'
          THEN oi.quantity * oi.unit_price - oi.discount ELSE 0 END
        ), 0), 2) AS revenue,
        COUNT(DISTINCT CASE WHEN o.status = 'DELIVERED' THEN o.order_id END) AS delivered_orders,
        COUNT(DISTINCT c.customer_id) AS customers,
        ROUND(COALESCE(SUM(
          CASE WHEN o.status = 'DELIVERED'
          THEN oi.quantity * (oi.unit_price - oi.unit_cost) - oi.discount ELSE 0 END
        ), 0), 2) AS gross_profit
      FROM customers c
      LEFT JOIN orders o ON o.customer_id = c.customer_id
      LEFT JOIN order_items oi ON oi.order_id = o.order_id
    `);

    const row = rows[0] || {};
    const revenue = Number(row.revenue || 0);
    const orders = Number(row.delivered_orders || 0);
    const profit = Number(row.gross_profit || 0);

    res.json({
      revenue,
      orders,
      customers: Number(row.customers || 0),
      averageOrderValue: orders ? Number((revenue / orders).toFixed(2)) : 0,
      grossProfit: profit,
      profitMargin: revenue ? Number(((profit / revenue) * 100).toFixed(2)) : 0
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.get("/api/monthly-sales", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        ROUND(SUM(oi.quantity * oi.unit_price - oi.discount), 2) AS revenue,
        COUNT(DISTINCT o.order_id) AS orders
      FROM orders o
      JOIN order_items oi ON oi.order_id = o.order_id
      WHERE o.status = 'DELIVERED'
      GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
      ORDER BY month
    `);
    res.json(rows.map(r => ({
      month: r.month,
      revenue: Number(r.revenue || 0),
      orders: Number(r.orders || 0)
    })));
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.get("/api/category-sales", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT
        c.category_name AS category,
        ROUND(SUM(
          CASE WHEN o.status = 'DELIVERED'
          THEN oi.quantity * oi.unit_price - oi.discount ELSE 0 END
        ), 2) AS revenue
      FROM categories c
      JOIN products p ON p.category_id = c.category_id
      LEFT JOIN order_items oi ON oi.product_id = p.product_id
      LEFT JOIN orders o ON o.order_id = oi.order_id
      GROUP BY c.category_id, c.category_name
      HAVING revenue > 0
      ORDER BY revenue DESC
    `);
    res.json(rows.map(r => ({
      category: r.category,
      revenue: Number(r.revenue || 0)
    })));
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.get("/api/top-products", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT
        p.product_name AS product,
        c.category_name AS category,
        SUM(CASE WHEN o.status = 'DELIVERED' THEN oi.quantity ELSE 0 END) AS units,
        ROUND(SUM(
          CASE WHEN o.status = 'DELIVERED'
          THEN oi.quantity * oi.unit_price - oi.discount ELSE 0 END
        ), 2) AS revenue
      FROM products p
      JOIN categories c ON c.category_id = p.category_id
      LEFT JOIN order_items oi ON oi.product_id = p.product_id
      LEFT JOIN orders o ON o.order_id = oi.order_id
      GROUP BY p.product_id, p.product_name, c.category_name
      HAVING revenue > 0
      ORDER BY revenue DESC
      LIMIT 5
    `);
    res.json(rows.map(r => ({
      product: r.product,
      category: r.category,
      units: Number(r.units || 0),
      revenue: Number(r.revenue || 0)
    })));
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.get("/api/order-status", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT status, COUNT(*) AS orders
      FROM orders
      GROUP BY status
      ORDER BY orders DESC
    `);
    res.json(rows.map(r => ({
      status: r.status,
      orders: Number(r.orders || 0)
    })));
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.get("/api/top-customers", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT
        vc.customer_id,
        vc.customer_name,
        vc.city,
        vc.state,
        vc.completed_orders,
        vc.lifetime_spend
      FROM vw_customer_360 vc
      ORDER BY vc.lifetime_spend DESC
      LIMIT 5
    `);
    res.json(rows.map(r => ({
      customerId: r.customer_id,
      customer: r.customer_name,
      location: [r.city, r.state].filter(Boolean).join(", "),
      orders: Number(r.completed_orders || 0),
      spend: Number(r.lifetime_spend || 0)
    })));
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.get("/api/profitability", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT
        c.category_name AS category,
        ROUND(SUM(
          CASE WHEN o.status = 'DELIVERED'
          THEN oi.quantity * oi.unit_price - oi.discount ELSE 0 END
        ), 2) AS revenue,
        ROUND(SUM(
          CASE WHEN o.status = 'DELIVERED'
          THEN oi.quantity * (oi.unit_price - oi.unit_cost) - oi.discount ELSE 0 END
        ), 2) AS profit
      FROM categories c
      JOIN products p ON p.category_id = c.category_id
      LEFT JOIN order_items oi ON oi.product_id = p.product_id
      LEFT JOIN orders o ON o.order_id = oi.order_id
      GROUP BY c.category_id, c.category_name
      HAVING revenue > 0
      ORDER BY revenue DESC
    `);
    res.json(rows.map(r => {
      const revenue = Number(r.revenue || 0);
      const profit = Number(r.profit || 0);
      return {
        category: r.category,
        revenue,
        profit,
        margin: revenue ? Number(((profit / revenue) * 100).toFixed(1)) : 0
      };
    }));
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.get("/api/recent-orders", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT
        order_id,
        customer_name,
        order_date,
        status,
        shipping_city,
        order_value
      FROM vw_order_summary
      ORDER BY order_date DESC
      LIMIT 8
    `);
    res.json(rows.map(r => ({
      orderId: r.order_id,
      customer: r.customer_name,
      date: r.order_date,
      status: r.status,
      city: r.shipping_city,
      amount: Number(r.order_value || 0)
    })));
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.get("/api/insights", async (_req, res) => {
  try {
    const [categoryRows, customerRows, stockRows, ratingRows] = await Promise.all([
      query(`
        SELECT
          c.category_name AS category,
          ROUND(SUM(
            CASE WHEN o.status = 'DELIVERED'
            THEN oi.quantity * oi.unit_price - oi.discount ELSE 0 END
          ), 2) AS revenue
        FROM categories c
        JOIN products p ON p.category_id = c.category_id
        LEFT JOIN order_items oi ON oi.product_id = p.product_id
        LEFT JOIN orders o ON o.order_id = oi.order_id
        GROUP BY c.category_id, c.category_name
        HAVING revenue > 0
        ORDER BY revenue DESC
        LIMIT 1
      `),
      query(`
        SELECT customer_name, lifetime_spend
        FROM vw_customer_360
        ORDER BY lifetime_spend DESC
        LIMIT 1
      `),
      query(`
        SELECT COUNT(*) AS low_stock
        FROM products
        WHERE stock_quantity <= reorder_level
      `),
      query(`
        SELECT ROUND(AVG(rating), 2) AS avg_rating
        FROM reviews
      `)
    ]);

    res.json({
      topCategory: categoryRows[0]?.category || "—",
      topCategoryRevenue: Number(categoryRows[0]?.revenue || 0),
      topCustomer: customerRows[0]?.customer_name || "—",
      topCustomerSpend: Number(customerRows[0]?.lifetime_spend || 0),
      lowStockProducts: Number(stockRows[0]?.low_stock || 0),
      averageRating: Number(ratingRows[0]?.avg_rating || 0)
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.use((err, _req, res, _next) => {
  console.error(err);
  res.status(500).json({ message: "Unexpected server error" });
});

const PORT = Number(process.env.PORT || 5000);

app.listen(PORT, () => {
  console.log(`E-Commerce Analytics API running on http://localhost:${PORT}`);
});
