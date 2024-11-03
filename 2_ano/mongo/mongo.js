postagem: {
    id: Number
    arquivoId: Number ?? null
    perfilId: Number 
    legenda: String 
    likes: [
        {
            perfilId: UUID, 
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

  
  


