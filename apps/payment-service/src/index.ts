import express from 'express';

const app = express();
app.use(express.json());

app.post('/api/v1/payments/invoices', async (req, res) => {
  const { amount_cents, currency } = req.body;
  res.json({ invoiceId: 'inv-123', status: 'issued', amount_cents, currency });
});

app.listen(3003, () => console.log('Payment service on port 3003'));
