db = db.getSiblingDB('mongo_incluses');  // Cria ou acessa o banco 'mongo_incluses'

// Insere documentos na coleção 'situacao_trabalhista'
db.situacao_trabalhista.insertMany([
  { id: "uuid1", nome: "empregado", userIds: ["uuid"] },
  { id: "uuid2", nome: "desempregado" },
]);
