import http from 'k6/http';
import { check, sleep } from 'k6';
import { randomString } from "https://jslib.k6.io/k6-utils/1.1.0/index.js";

export let options = {
  vus: 10,
  iterations: 200,
};

function createPayload() {
    const email = randomString(10);
    const payload = {
        email: `${email}@gmail.com`,
    };
    return JSON.stringify(payload);
}

export default function () {
    // GET request
    const url = 'https://TOCHANGE/api/feed';
    const res = http.get(url);
    
    // POST request with dynamic payload
    // const url = 'https://xxxxxxx/newsletter';
    // const headers = { 'Content-Type': 'application/json' };
    // const payload = createPayload();
    // const res = http.post(url, payload, { headers: headers });

    check(res, {
        'status was 200': (r) => r.status == 200,
        'transaction time OK': (r) => r.timings.duration < 500,
    });

    sleep(1);
}
