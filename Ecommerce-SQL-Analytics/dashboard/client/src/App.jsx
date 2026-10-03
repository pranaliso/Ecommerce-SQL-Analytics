import { useEffect, useMemo, useState } from "react";
import {
  BarChart3,
  Boxes,
  CircleDollarSign,
  Database,
  LayoutDashboard,
  Package,
  RefreshCw,
  ShoppingCart,
  Users,
  WalletCards
} from "lucide-react";
import {
  Bar,
  BarChart,
  CartesianGrid,
  Cell,
  Legend,
  Line,
  LineChart,
  Pie,
  PieChart,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis
} from "recharts";

const money = (value) =>
  new Intl.NumberFormat("en-IN", {
    style: "currency",
    currency: "INR",
    maximumFractionDigits: 0
  }).format(Number(value || 0));

const number = (value) =>
  new Intl.NumberFormat("en-IN").format(Number(value || 0));

const API = "/api";

async function getData(path) {
  const response = await fetch(`${API}${path}`);
  const data = await response.json();
  if (!response.ok) throw new Error(data.message || "Request failed");
  return data;
}

function StatCard({ icon: Icon, label, value, helper }) {
  return (
    <div className="stat-card">
      <div className="stat-icon"><Icon size={20} /></div>
      <div>
        <span>{label}</span>
        <strong>{value}</strong>
        <small>{helper}</small>
      </div>
    </div>
  );
}

function Panel({ title, subtitle, children, className = "" }) {
  return (
    <section className={`panel ${className}`}>
      <div className="panel-head">
        <div>
          <h2>{title}</h2>
          {subtitle && <p>{subtitle}</p>}
        </div>
      </div>
      {children}
    </section>
  );
}

function App() {
  const [data, setData] = useState(null);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);
  const [lastUpdated, setLastUpdated] = useState(null);

  const loadDashboard = async () => {
    setLoading(true);
    setError("");
    try {
      const [
        overview,
        monthlySales,
        categorySales,
        topProducts,
        orderStatus,
        topCustomers,
        profitability,
        recentOrders,
        insights,
        health
      ] = await Promise.all([
        getData("/overview"),
        getData("/monthly-sales"),
        getData("/category-sales"),
        getData("/top-products"),
        getData("/order-status"),
        getData("/top-customers"),
        getData("/profitability"),
        getData("/recent-orders"),
        getData("/insights"),
        getData("/health")
      ]);

      setData({
        overview,
        monthlySales,
        categorySales,
        topProducts,
        orderStatus,
        topCustomers,
        profitability,
        recentOrders,
        insights,
        health
      });
      setLastUpdated(new Date());
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadDashboard();
  }, []);

  const categoryTotal = useMemo(
    () => (data?.categorySales || []).reduce((sum, item) => sum + item.revenue, 0),
    [data]
  );

  if (loading && !data) {
    return <div className="loading-screen"><div className="spinner" />Loading analytics...</div>;
  }

  if (error && !data) {
    return (
      <div className="error-screen">
        <Database size={42} />
        <h1>Dashboard could not connect</h1>
        <p>{error}</p>
        <div className="error-help">
          Make sure MySQL is running, the <code>ecommerce_analytics</code> database exists,
          the SQL schema/data/views have been executed, and the API is running on port 5000.
        </div>
        <button onClick={loadDashboard}><RefreshCw size={17} /> Retry</button>
      </div>
    );
  }

  const o = data?.overview || {};
  const i = data?.insights || {};

  return (
    <div className="app-shell">
      <aside className="sidebar">
        <div className="brand">
          <div className="brand-mark"><BarChart3 size={22} /></div>
          <div>
            <strong>E-Commerce</strong>
            <span>SQL Analytics</span>
          </div>
        </div>

        <nav>
          <a className="active"><LayoutDashboard size={18} /> Overview</a>
          <a><BarChart3 size={18} /> Sales Analysis</a>
          <a><Users size={18} /> Customer Analytics</a>
          <a><Package size={18} /> Product Analytics</a>
          <a><CircleDollarSign size={18} /> Profitability</a>
          <a><Boxes size={18} /> Inventory</a>
          <a><Database size={18} /> Data Quality</a>
        </nav>

        <div className="db-status">
          <span className="status-dot" />
          <div>
            <strong>MySQL Connected</strong>
            <small>ecommerce_analytics</small>
          </div>
        </div>
      </aside>

      <main className="main">
        <header className="topbar">
          <div>
            <div className="eyebrow">MYSQL 8+ • BUSINESS INTELLIGENCE</div>
            <h1>Business Overview</h1>
            <p>Live metrics calculated from your E-Commerce SQL database.</p>
          </div>
          <button className="refresh-btn" onClick={loadDashboard} disabled={loading}>
            <RefreshCw size={17} className={loading ? "spin" : ""} />
            Refresh
          </button>
        </header>

        {error && <div className="inline-error">{error}</div>}

        <div className="stats-grid">
          <StatCard icon={WalletCards} label="Total Revenue" value={money(o.revenue)} helper="Delivered orders" />
          <StatCard icon={ShoppingCart} label="Delivered Orders" value={number(o.orders)} helper="Completed purchases" />
          <StatCard icon={Users} label="Customers" value={number(o.customers)} helper="Across the database" />
          <StatCard icon={CircleDollarSign} label="Average Order Value" value={money(o.averageOrderValue)} helper="Revenue per delivered order" />
          <StatCard icon={BarChart3} label="Profit Margin" value={`${o.profitMargin || 0}%`} helper={`${money(o.grossProfit)} gross profit`} />
        </div>

        <div className="grid-two">
          <Panel title="Monthly Sales Trend" subtitle="Delivered-order revenue by month">
            <div className="chart">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={data?.monthlySales || []}>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} />
                  <XAxis dataKey="month" tickLine={false} axisLine={false} />
                  <YAxis tickLine={false} axisLine={false} tickFormatter={(v) => `₹${Math.round(v / 1000)}k`} />
                  <Tooltip formatter={(v) => money(v)} />
                  <Line type="monotone" dataKey="revenue" stroke="#3b82f6" strokeWidth={3} dot={{ r: 3 }} />
                </LineChart>
              </ResponsiveContainer>
            </div>
          </Panel>

          <Panel title="Sales by Category" subtitle={`${money(categoryTotal)} delivered revenue`}>
            <div className="chart">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie data={data?.categorySales || []} dataKey="revenue" nameKey="category" innerRadius={62} outerRadius={94} paddingAngle={3}>
                    {(data?.categorySales || []).map((_, idx) => (
                      <Cell key={idx} fill={["#3b82f6","#22c55e","#f59e0b","#8b5cf6","#ec4899","#14b8a6"][idx % 6]} />
                    ))}
                  </Pie>
                  <Tooltip formatter={(v) => money(v)} />
                  <Legend verticalAlign="bottom" height={36} />
                </PieChart>
              </ResponsiveContainer>
            </div>
          </Panel>
        </div>

        <div className="grid-two">
          <Panel title="Top Products by Revenue" subtitle="Best-performing delivered products">
            <div className="chart">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={data?.topProducts || []} layout="vertical" margin={{ left: 15, right: 20 }}>
                  <CartesianGrid strokeDasharray="3 3" horizontal={false} />
                  <XAxis type="number" tickFormatter={(v) => `₹${Math.round(v / 1000)}k`} />
                  <YAxis type="category" dataKey="product" width={125} tickLine={false} />
                  <Tooltip formatter={(v) => money(v)} />
                  <Bar dataKey="revenue" fill="#3b82f6" radius={[0, 5, 5, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </Panel>

          <Panel title="Order Status" subtitle="Current order distribution">
            <div className="chart">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie data={data?.orderStatus || []} dataKey="orders" nameKey="status" innerRadius={58} outerRadius={90}>
                    {(data?.orderStatus || []).map((_, idx) => (
                      <Cell key={idx} fill={["#22c55e","#3b82f6","#f59e0b","#ef4444","#8b5cf6"][idx % 5]} />
                    ))}
                  </Pie>
                  <Tooltip formatter={(v) => number(v)} />
                  <Legend verticalAlign="bottom" height={36} />
                </PieChart>
              </ResponsiveContainer>
            </div>
          </Panel>
        </div>

        <div className="grid-three">
          <Panel title="Top Customers" subtitle="Highest lifetime spend">
            <div className="table-wrap">
              <table>
                <thead><tr><th>Customer</th><th>Orders</th><th>Spend</th></tr></thead>
                <tbody>
                  {(data?.topCustomers || []).map((row) => (
                    <tr key={row.customerId}>
                      <td><strong>{row.customer}</strong><small>{row.location || "—"}</small></td>
                      <td>{row.orders}</td>
                      <td>{money(row.spend)}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </Panel>

          <Panel title="Profitability by Category" subtitle="Revenue vs gross profit">
            <div className="table-wrap">
              <table>
                <thead><tr><th>Category</th><th>Revenue</th><th>Margin</th></tr></thead>
                <tbody>
                  {(data?.profitability || []).slice(0, 6).map((row) => (
                    <tr key={row.category}>
                      <td>{row.category}</td>
                      <td>{money(row.revenue)}</td>
                      <td><span className="pill">{row.margin}%</span></td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </Panel>

          <Panel title="Customer & Data Insights" subtitle="Live observations">
            <div className="insights">
              <div><span className="insight-dot blue" /><p><strong>{i.topCategory}</strong> is the top revenue category at {money(i.topCategoryRevenue)}.</p></div>
              <div><span className="insight-dot green" /><p><strong>{i.topCustomer}</strong> has the highest lifetime spend at {money(i.topCustomerSpend)}.</p></div>
              <div><span className="insight-dot amber" /><p><strong>{i.lowStockProducts}</strong> products are at or below their reorder level.</p></div>
              <div><span className="insight-dot purple" /><p>Average product review rating is <strong>{i.averageRating}/5</strong>.</p></div>
            </div>
          </Panel>
        </div>

        <Panel title="Recent Orders" subtitle="Latest records from vw_order_summary">
          <div className="table-wrap">
            <table className="wide-table">
              <thead>
                <tr><th>Order ID</th><th>Customer</th><th>Date</th><th>City</th><th>Status</th><th>Amount</th></tr>
              </thead>
              <tbody>
                {(data?.recentOrders || []).map((row) => (
                  <tr key={row.orderId}>
                    <td>#{row.orderId}</td>
                    <td>{row.customer}</td>
                    <td>{new Date(row.date).toLocaleString("en-IN")}</td>
                    <td>{row.city}</td>
                    <td><span className={`status ${row.status.toLowerCase()}`}>{row.status}</span></td>
                    <td><strong>{money(row.amount)}</strong></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </Panel>

        <footer>
          <span>E-Commerce SQL Analytics</span>
          <span>MySQL + Express + React + Recharts</span>
          <span>{lastUpdated ? `Updated ${lastUpdated.toLocaleTimeString("en-IN")}` : "Not updated yet"}</span>
        </footer>
      </main>
    </div>
  );
}

export default App;
