const cds = require('@sap/cds');

// Registrar health check endpoint ao inicializar
cds.on('bootstrap', (app) => {
    app.get('/health', (req, res) => {
        res.status(200).json({ status: 'healthy' });
    });
});

module.exports = cds.server;
