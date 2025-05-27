import http from 'k6/http';
import { check } from "k6";
import encoding from "k6/encoding";

export const options = {
    thresholds: {
        checks: ['rate==1'], // the rate of successful checks should be 100%
    },
    stages: [
        {duration: '30s', target: 10},
        {duration: '30s', target: 25},
        {duration: '30s', target: 10},
        {duration: '30s', target: 0},
    ],
};

const URL = __ENV.TARGET_URL || 'https://example.com';
const BASIC_AUTH_USER = __ENV.BASIC_AUTH_USER || 'user';
const BASIC_AUTH_PASS = __ENV.BASIC_AUTH_PASS || 'pass';

export default function () {
    const headers = {
        'Authorization': `Basic ${encoding.b64encode(`${BASIC_AUTH_USER}:${BASIC_AUTH_PASS}`)}`,
        'Content-Type': 'application/json',
    };

    const res = http.get(URL, {
        headers: headers,
        tags: { name: 'get' },
    });
    check(res, {
        'is status 200': (r) => r.status === 200,
    });
}