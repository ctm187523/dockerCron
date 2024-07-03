
let times = 0;  //bandera para mostrar cada vez que se hace un tick

const syncDB = () => {
    
    times++;
    console.log('Tick cada 5 segundos', times);

    return times;
}

module.exports = {
    syncDB
}