#El docker file son instrucciones para crear la imagen
#una vez creado el DockerFile para construir la imagen usamos -> docker build --tag cron-ticker .
#FIJARSE ABAJO QUE AHORA SI QUUEREMOS CONSTRUIR IMAGENES MULTIARQUITECTURAS CON buildx USAMOS UN BUILD DISTINTO
#con --tag ponemos el nombre que queremos de la imagen y el punto final hace referencia a este directorio
#donde se encuentra el docker file
#una vez construida la imagen la podemos ejecutar con docker container run cron-ticker
#para hacer el testing de la creación de la imagen instalamos --> sudo npm i jest --save-dev



#nos basamos generalmente de otras imagenes las importamos con FROM en este caso de Node
#es el punto inicial de entrada, alpine es un sitema ligero de linux con Node ya instalado
#si añadimos despues del FROM  --platform=amd64 indicamos la arquitectura del ordenador donde queramos que corra esta imagen
#si omitimos --platform=arm64 se crea para la plataforma de mi ordenado que seria --platform=amd64
# FROM node:19.2-alpine3.17    #la comentamos usamos abajo buildx para multiples plataformas
# FROM --platform=arm64 node:19.2-alpine3.17    #la comentamos usamos abajo buildx para multiples plataformas

#para usar multiples plataformas instalamos buildx--> docker buildx create --name mybuilder --bootstrap --use
#despues tenemos que ejecutar en la terminal -> docker buildx use mybuilder
#ver documentacion --> https://docs.docker.com/build/building/multi-platform/#getting-started
# se crean las variables de entorno BUILDPLATFORM y TARGETPLATFORM
# PARA CONSTUIR AHORA LA IMAGEN USAMOS:
# docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7,linux/arm64/v8 \
# -t ducados75/cron-ticker:latest --push .
# son las 2 lineas de arriba para la construccion esto nos sube directamente a dockerhub la imagen ya que hace el push y
#la crea para 3 arquitecturas de computadoras, hay que asegurarse que la imagen que usamos soporte esas arquitecturas
#COMENTAMOS DE NUEVO HAY OTRA MANERA DE HACERDO CON buildx
#FROM --platform=$BUILDPLATFORM node:19.2-alpine3.17    

#usamos de nuevo buildx para crear la imagen paralas diferentes arquitecturas
#fijarse que no esta como arriba comentado haciendo referencia a la variable de entorno BUILDPLATFORM -> --platform=$BUILDPLATFORM
#PARA CREAR LA IMAGEN EN LA TERMINAL -->como antes cambiamos el tag solo
#docker buildx build \--platform linux/amd64,linux/arm64,linux/arm/v7 \-t ducados75/cron-ticker:anotherOne --push .
FROM node:19.2-alpine3.17


# /app esta version de alpine ya viene con una carpeta llamada app donde podemos poner la app
# se pueden usar otros directorios
#especificamos el directorio donde queremos trabajar que es este /app que ya viene con alpine
# es como hacer -> cd app
WORKDIR /app   


# Copiamos en el directorio app de la imagen de Alpine con node el package.json
# el destino es ./ el directorio app donde nos encontramos
COPY package.json ./   

#Con RUN ejecutamos comandos en este caso el comando que queremos ejecutar es
#npm install que instala las dependencias de la app, basadas en el contenido del package.json
RUN npm install

#Copiamos en el directorio app todos los archivos de la aplicacion con el primer punto indicamos que queremos copiar todo
#y con el segundo punto que lo copiemos en el directorio app
#esto lo copia todo, usaremo el .dockerignore para indicar los archivos y directorios que no queremos copiar
#como los modulos de Node, que queremos que se instalen, ver arriba -> RUN npm install dependiendo de lo que necesitemos para la aplicación
COPY . .


# Realizar testing, creara la imagen si pasa el testing
RUN npm run test

#una vez pasado el testing eliminamos dependencias innecesarias para producción
#r(recursivo)f(forzado), borranos la carpeta de tests ya que una vez pasado el test no lo vamos a volver a utilzar
#borramos tambien los node_modules para reconstruirlos de nuevo pero con solo los de produccion ya que ahora tenemos instalados todas las dependencias
#concatenamos las 2 sentencias en una misma linea con el operador &&
RUN rm -rf tests && rm -rf node_modules

#ahora instalamos de node solo las dependencias necesarias para produccion
RUN npm install --prod


#para que la aplicacion corra debemos ejecutar los comandos de ejecucion pueden ser npm start o node app
#para ello usamos CMD, es el comando run de la imagen separamos por comas las sentencias
CMD [ "node","app.js" ]