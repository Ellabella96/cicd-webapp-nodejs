const request = require('supertest');
const app = require('../server');

describe('Health Endpoints', () => {
  describe('Health Check Endpoints', () => {
    it('should return healthy status with all required fields', async () => {
      const response = await request(app).get('/health');

      expect(response.status).toBe(200);
      expect(response.body).toMatchObject({
        status: 'healthy',
        service: 'cicd-webapp-nodejs'
      });

      // Check that timestamp is a valid ISO string
      expect(new Date(response.body.timestamp)).toBeInstanceOf(Date);

      // Check that uptime is a number
      expect(typeof response.body.uptime).toBe('number');
      expect(response.body.uptime).toBeGreaterThan(0);
    });

    it('should return ready status', async () => {
      const response = await request(app).get('/health/ready');

      expect(response.status).toBe(200);
      expect(response.body).toEqual({ status: 'ready' });
    });

    it('should return alive status', async () => {
      const response = await request(app).get('/health/live');

      expect(response.status).toBe(200);
      expect(response.body).toEqual({ status: 'alive' });
    });
  });

  describe('Health Check Response Format', () => {
    it('should return JSON content type', async () => {
      const response = await request(app).get('/health');

      expect(response.header['content-type']).toMatch(/application\/json/);
    });

    it('should have consistent response time', async () => {
      const start = Date.now();
      const response = await request(app).get('/health');
      const duration = Date.now() - start;

      expect(response.status).toBe(200);
      expect(duration).toBeLessThan(1000); // Should respond within 1 second
    });
  });
});
