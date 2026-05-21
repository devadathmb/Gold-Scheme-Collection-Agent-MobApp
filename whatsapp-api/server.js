const express = require('express');
const { Client, LocalAuth } = require('whatsapp-web.js');
const qrcode = require('qrcode-terminal');

const app = express();
app.use(express.json());

const client = new Client({ authStrategy: new LocalAuth() });

client.on('qr', qr => qrcode.generate(qr, { small: true }));
client.on('ready', () => console.log('WhatsApp Client is ready!'));

app.post('/send-message', async (req, res) => {
    const { phone, message } = req.body;
    if (!phone || !message) return res.status(400).json({ error: 'Missing data' });
    
    try {
        await client.sendMessage(`91${phone}@c.us`, message);
        res.status(200).json({ success: true });
    } catch (error) {
        res.status(500).json({ error: 'Failed to send' });
    }
});

client.initialize();
app.listen(3000, () => console.log('Server running on port 3000'));