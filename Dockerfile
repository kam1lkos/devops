FROM nginx:1.23.4

COPY ./deployed-to-nginx/index.html /usr/share/nginx/html/

#to jest chyba niepotrzebne
RUN chmod +r /usr/share/nginx/html/index.html

EXPOSE 80

#tak jest podane w dok nginxa; czy naprawdę powinien działać w foregroundzie?
CMD ["nginx", "-g", "daemon off;"]
