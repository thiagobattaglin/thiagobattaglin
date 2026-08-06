service ProcessamentoService {

    // Action que recebe um código numérico e retorna uma mensagem
    action processar(codigo : Integer) returns {
        mensagem : String;
        codigo   : Integer;
        status   : String;
    };
}
