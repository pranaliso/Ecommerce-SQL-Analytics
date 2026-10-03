# E-Commerce SQL Analytics Dashboard

A real React + Express dashboard connected directly to the **MySQL `ecommerce_analytics` database** from the `Ecommerce-SQL-Analytics` project.

## Stack

- MySQL 8+
- Node.js + Express
- React + Vite
- Recharts
- mysql2
- dotenv

## Project structure

```text
dashboard/
├── server/
│   ├── .env.example
│   ├── package.json
│   └── server.js
└── client/
    ├── package.json
    ├── index.html
    └── src/
        ├── App.jsx
        ├── main.jsx
        └── styles.css
```

## 1. Prepare the MySQL database

From the parent SQL project, run these in MySQL Workbench in this order:

```text
database/01_schema.sql
database/02_seed_data.sql
views/analytics_views.sql
```

The database name is:

```text
ecommerce_analytics
```

## 2. Configure the API

Copy:

```text
server/.env.example
```

to:

```text
server/.env
```

Then set your MySQL username/password.

Example:

```env
PORT=5000
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=ecommerce_analytics
```

Do not commit `.env`.

## 3. Install dependencies

From the `dashboard` folder:

```bash
npm run install-all
```

## 4. Start the backend

```bash
npm run server
```

API:

```text
http://localhost:5000
```

## 5. Start the React dashboard

Open a second terminal:

```bash
npm run client
```

Open the Vite URL shown in the terminal, normally:

```text
http://localhost:5173
```

## Dashboard data

The dashboard calculates its metrics from the actual SQL database:

- Revenue
- Delivered orders
- Customers
- Average order value
- Gross profit and margin
- Monthly sales
- Sales by category
- Top products
- Order status
- Top customers
- Category profitability
- Recent orders
- Customer insights

No hard-coded dashboard numbers are used.
