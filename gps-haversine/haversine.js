#!/usr/bin/env node

const args = process.argv;
const point1 = args[args.length - 2];
const point2 = args[args.length - 1];

function haversine(lat1, lon1, lat2, lon2) {
    const R = 6371e3; // metres
    const fi1 = lat1 * Math.PI/180; // φ, λ in radians
    const fi2 = lat2 * Math.PI/180;
    const deltafi = (lat2-lat1) * Math.PI/180;
    const deltalambda = (lon2-lon1) * Math.PI/180;
    const a = Math.sin(deltafi/2) * Math.sin(deltafi/2) +
            Math.cos(fi1) * Math.cos(fi2) *
            Math.sin(deltalambda/2) * Math.sin(deltalambda/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    return R * c; // in metres
}

console.log (haversine (point1.split(',')[0],point1.split(',')[1],point2.split(',')[0],point2.split(',')[1]))
