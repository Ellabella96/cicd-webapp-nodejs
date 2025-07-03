const request = require('supertest');
const app = require('../server');

describe('Metrics Endpoints', () => {
  describe('GET /metrics', () => {
    it('should return Prometheus metrics format', async () => {
      const response = await request(app).get('/metrics');
      
      expect(response.status).toBe(200);
      expect(response.header['content-type']).toMatch(/text\/plain/);
    });

    it('should include default Node.js metrics', async () => {
      const response = await request(app).get('/metrics');
      
      expect(response.text).toContain('process_cpu_user_seconds_total');
      expect(response.text).toContain('process_resident_memory_bytes');
      expect(response.text).toContain('nodejs_version_info');
    });

    it('should include custom application metrics', async () => {
      const response = await request(app).get('/metrics');
      
      expect(response.text).toContain('http_requests_total');
      expect(response.text).toContain('http_request_duration_seconds');
    });

    it('should include app label in metrics', async () => {
      const response = await request(app).get('/metrics');
      
      expect(response.text).toContain('app="cicd-webapp-nodejs"');
    });

    it('should track metrics after making requests', async () => {
      // Make a request to generate metrics
      await request(app).get('/health');
      
      // Check that metrics were recorded
      const response = await request(app).get('/metrics');
      expect(response.text).toContain('http_requests_total');
    });
  });
});
