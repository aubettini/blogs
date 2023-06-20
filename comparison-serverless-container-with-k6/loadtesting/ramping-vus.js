import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  discardResponseBodies: true,
  scenarios: {
    contacts: {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: '400s', target: 300 },
      ],
      gracefulRampDown: '0s',
    },
  },
};

export default function () {
    http.get('https://xc6wex5xm1.execute-api.eu-west-1.amazonaws.com/item');
    sleep(0.5)
}
