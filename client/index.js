var uuid = require('node-uuid');

const randRange = (min, max) => Math.floor(Math.random() * (max - min + 1) + min);

const sensorStatus = ["OK", "WARN", "NG"];
const randStatus = sensorStatus[Math.floor(Math.random() * sensorStatus.length)];

const sensor_id = uuid.v4();

module.exports = async function (context, myTimer) {

    context.bindings.telemetryDocument = JSON.stringify({
        sensor_id: sensor_id,
        temperature: randRange(0, 40),
        sensor_status: randStatus
    })

    context.log(context.bindings.telemetryDocument);

    context.log('JavaScript timer trigger function ran!');   
};