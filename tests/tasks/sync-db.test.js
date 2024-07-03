const { syncDB } = require("../../tasks/sync-db");

//en el package.json en el apartado scripts en test hemos puesto jest
//al crear una imagen si tenemos incluido el testing y falla no se crea la imagen
describe('Pruebas en Sync-DB', () => { 
    
    test('debe de ejecutar el proceso 2 veces', () => { 

        syncDB();    //lo llamamos una vez
        const times = syncDB(); //la funcion syncDB devuelve un número que son las veces que llamamos a la función, lo llamamos una segunda vez
        console.log('Se llamo ', times );

        expect( times ).toBe( 2 );  // con expect indicamos que esperamos que times se ejecute 2 veces, nos devuelva 2 veces times la función en sync-db.js
    })

});