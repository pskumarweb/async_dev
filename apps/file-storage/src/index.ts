import Fastify from 'fastify';
import multipart from '@fastify/multipart';

const fastify = Fastify({ logger: true });
fastify.register(multipart);

fastify.post('/upload', async (request, reply) => {
  const data = await request.file();
  if (!data) return reply.code(400).send({ error: 'No file uploaded' });
  
  return { id: 'file-id', filename: data.filename, url: '/files/file-id' };
});

fastify.listen({ port: 3002, host: '0.0.0.0' });
