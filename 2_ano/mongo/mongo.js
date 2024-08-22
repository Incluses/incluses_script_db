postagem: {
    id: Number
    arquivoId: Number ?? null
    perfilId: Number 
    titulo: String
    legenda: String 
}

likes: {
    id: Number
    postagemId: Number
    perfilId: Number
    like: Boolean
    data_like: Date
}

comentarios: {
    id: Number
    postagemId: Number
    perfilId: Number
    comentario: String
}

reacoes: {
    id: Number
    comentarioId: Number
    postagemId: Number
    perfilId: Number
    reacao: String
}

funcoes: {
    nome: String
    userIds: [Number]
}



// Pode ser feito?

// Conversas: {
//     id: Number;
//     tipo: [publico, privado]
//     nome: String
//     participantes: [
//       {
//         perfilId: Number,
//         adicionado_em: Date,
//         ultimo_acesso: Date
//       }
//     ]
//     criador_id: Number
//     data_criacao: Date
// }

// Mensagem: {
//     id: Number
//     conversa_id: Number
//     remetente_id: Number
//     conteudo: String
//     data_envio: Date
//     status: [lido, nao_lido]
// }
  
  


