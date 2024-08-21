Post: {
    id: Number
    attachmentId: Number ?? null
    perfilId: Number 
    title: String
    label: String 
}

Like: {
    id: Number
    postId: Number
    perfilId: Number
    like: Boolean
    data_like: Date
}

Comment: {
    id: Number
    postId: Number
    perfilId: Number
    comment: String
}

Reaction: {
    id: Number
    commentId: Number
    postId: Number
    perfilId: Number
    reaction: String
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
  
  


