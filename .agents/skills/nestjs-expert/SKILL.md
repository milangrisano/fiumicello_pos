---
name: nestjs-expert
description: Guide for building scalable server-side applications using NestJS, a progressive Node.js framework.
---

# NestJS Expert Skill

## Overview
Nest (NestJS) is a framework for building efficient, scalable Node.js server-side applications. It uses progressive JavaScript, is built with and fully supports TypeScript (while preserving compatibility with pure JavaScript), and combines elements of OOP (Object Oriented Programming), FP (Functional Programming), and FRP (Functional Reactive Programming).

Under the hood, Nest makes use of robust HTTP Server frameworks like Express (the default) and optionally can be configured to use Fastify, allowing for easy use of the myriad of third-party plugins which are available.

## Philosophy
While there are a lot of superb libraries, helpers, and tools for Node.js, very few of them effectively solve the main problem - the architecture.

Nest aims to provide an application architecture out of the box which allows for effortless creation of highly testable, scalable, loosely coupled, and easily maintainable applications. The architecture is heavily inspired by Angular.

## Core Concepts
- **Controllers**: Responsible for handling incoming requests and returning responses to the client.
- **Providers**: Almost everything is a provider (services, repositories, factories, helpers, etc.). They can be injected as dependencies.
- **Modules**: Used to organize the application structure into cohesive blocks of functionality. Every Nest application has at least one module (the root module).
- **Middleware**: Functions called before the route handler.
- **Exception Filters**: Responsible for processing all unhandled exceptions across an application.
- **Pipes**: Used for transformation and validation of input data.
- **Guards**: Determine whether a given request will be handled by the route handler or not, depending on certain conditions (e.g., authentication, permissions, roles).
- **Interceptors**: Bind extra logic before or after method execution, transform the result or exception, or extend basic function behavior.

## Working with NestJS
When acting under the `nestjs-expert` skill, always emphasize:
1. **TypeScript First**: Leverage strong typing, interfaces, and decorators.
2. **Modular Architecture**: Group related components, controllers, and services into self-contained Feature Modules.
3. **Dependency Injection**: Utilize constructor-based injection for services to keep code highly testable and loosely coupled.
4. **Validation**: Rely on strictly typed Data Transfer Objects (DTOs) for incoming payloads and the built-in `ValidationPipe` for seamless validation.

## Official Resources
- [NestJS Documentation](https://docs.nestjs.com/)
- [GitHub Repository](https://github.com/nestjs/nest)
