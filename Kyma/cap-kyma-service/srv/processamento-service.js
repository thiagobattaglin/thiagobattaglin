const cds = require('@sap/cds');

module.exports = class ProcessamentoService extends cds.ApplicationService {

    init() {
        this.on('processar', this._onProcessar);
        return super.init();
    }

    async _onProcessar(req) {
        const { codigo } = req.data;

        if (codigo === undefined || codigo === null) {
            return req.reject(400, 'O campo "codigo" é obrigatório e deve ser um número.');
        }

        console.log(`[ProcessamentoService] Código recebido: ${codigo}`);

        return {
            mensagem: 'Processado com sucesso',
            codigo: codigo,
            status: 'OK'
        };
    }
};
