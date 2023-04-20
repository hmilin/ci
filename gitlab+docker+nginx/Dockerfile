FROM node:18-alpine as builder

WORKDIR /fe
# 开启corepack 无需安装pnpm
RUN corepack enable

# 先复制配置文件，配置无变更时，node_modules层级以下的镜像缓存会被复用
COPY .npmrc package.json pnpm-lock.yaml ./
COPY patches/ ./patches/

RUN --mount=type=cache,id=pnpm-store,target=/root/.pnpm-store \
  pnpm install --no-optional

COPY . .
RUN pnpm build


FROM nginx:1.23.3

WORKDIR /usr/local/web

# Redirect standard output and error stream
RUN mkdir -p logs && \
  ln -s /dev/stdout logs/access.log && \
  ln -s /dev/stderr logs/error.log

COPY nginx/startup.sh .
COPY nginx/conf/ conf/
COPY --from=builder /fe/dist/fe/ html/


ENV CONTAINERIZED true

EXPOSE 80
# Run Command
CMD sh startup.sh
