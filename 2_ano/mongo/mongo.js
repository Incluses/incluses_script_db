postagem: {
    id: Number
    arquivoId: Number ?? null
    perfilId: Number 
    titulo: String
    legenda: String 
    likes: [
        {
            perfilId: Number, 
            data_like: Date
        }
    ]
    comentarios: [
        {
            perfilId: Number, 
            comentario: String,
        }
    ]
}

funcoes: {
    nome: String
    userIds: [Number]
}

Conversas: {
    id: Number;
    tipo: [publico, privado]
    nome: String ?? null
    participantes: [
      {
        perfilId: Number,
        adicionado_em: Date
      }
    ]
    criador_id: Number
    data_criacao: Date
    mensagem: [
        {
            perfilId: Number,
            conteudo: String,
            data_envio: Date
        }
    ]
}

  
  


