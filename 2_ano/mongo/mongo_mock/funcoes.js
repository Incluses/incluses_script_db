db = db.getSiblingDB('mongo_incluses');  // Cria ou acessa o banco 'mongo_incluses'

// Insere documentos na coleção 'funcoes'
db.funcoes.insertMany([
  { nome: "Administrador", userIds: [1] },
  { nome: "Desenvolvedor" },
  { nome: "Designer" },
  { nome: "Gerente de Projetos" }
]);
