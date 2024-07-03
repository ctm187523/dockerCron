
//hemos creado la app con npm init en el directorio cron-ticker, crea el package.json
//una vez creado el package.json he creado este archivo app.js vacio 
//hemos instalado node-cron con --> npm i node-cron
//en el package.json hemos puesto en la parte de los scripts
//para sincronizar que ocurra algo en un determinado tiempo ver --> https://www.npmjs.com/package/node-cron
// "start": "node app.js" para que se ejecute con ->  npm start
// tambien podemos ejecutarlo con node --> node app.js
// para subir la imagen a docker hub ver video -> Subir imagen a Docker

const  cron = require('node-cron');
const { syncDB } = require('./tasks/sync-db');   //funcion creada por mi

console.log('Inicio de la app');

//ver en el link de arriba el funcionamiento los asteriscos dicen cada cuanto se tiene que ejecutar la accion
// 6 asteriscos como esta aqui es cada segundo asi cada segundo se ejecuta el texto del console.log
//dividimos entre 5 para que se ejecute cada 5 segundos
cron.schedule('1-59/5 * * * * * *', syncDB);   //llamamos a la funcion creada en el archivo sync-db.js del directorio tasks del proyecto

