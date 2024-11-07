const swaggerDefinition = {
  openapi: "3.0.0",
  info: {
    title: "API",
    version: "1.0.0",
  },
  servers: [
    {
      url: "http://192.168.1.35:3001",
      description: "Development server",
    },
    {
      url: "http://localhost:3001",
      description: "localhost",
    },
  ],
  components: {
    securitySchemes: {
      BearerAuth: {
        type: "http",
        scheme: "bearer",
        in: "header",
        bearerFormat: "JWT",
      },
    },
    schemas: {},
  },
  security: [
    {
      BearerAuth: [],
    },
  ],
  swagger: "3.0",
};

module.exports = swaggerDefinition;
