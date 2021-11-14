const weather = true;
const date = new Promise((resolve, reject) => {
    if (weather) {
        const dateDetails = {
            name: 'Cubana Restaurant',
            location: '55th Street',
            table: 5
        };

        resolve(dateDetails);
    } else {
        reject(new Error('Bad weather, so no Date'))
    }
});

const orderUber = dateDetails => {
    const message = `Get me an Uber ASAP to ${dateDetails.location}, we are going on a date!`;
    return Promise.resolve(message);
}

async function myDate() {
    try {
        let dateDetails = await date;
        let message = await orderUber(dateDetails);
        console.log(message);
    } catch (err) {
        console.log(err.message);
    }
}



