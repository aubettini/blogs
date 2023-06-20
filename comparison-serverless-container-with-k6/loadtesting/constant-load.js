import http from 'k6/http';
import { sleep } from 'k6';

// Constant VUs and load
export const options = {
    discardResponseBodies: true,
    scenarios: {
      contacts: {
        executor: 'constant-vus',
        vus: 10,
        duration: '120s',
      },
    },
  };

export default function () {
    http.get('https://xc6wex5xm1.execute-api.eu-west-1.amazonaws.com/item');
    sleep(0.5)
}
