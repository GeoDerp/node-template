FROM registry.access.redhat.com/ubi9/ubi:latest

RUN dnf update -y; \
# Install git & nano 
dnf install git nano -y; \
# clear cache
rm -rf /var/cache

# Install nvm
WORKDIR /root
ADD https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh /root/
RUN chmod +x /root/install.sh && /root/install.sh
RUN export NVM_DIR="$HOME/.nvm"; \
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; \ 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"; \
nvm install --latest-npm lts/*

# Install Trivy 
RUN <<EOF cat >> /etc/yum.repos.d/trivy.repo
[trivy]
name=Trivy repository
baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://aquasecurity.github.io/trivy-repo/rpm/public.key
EOF
RUN dnf update -y; dnf install trivy -y; rm -rf /var/cache

#Install angular 
RUN source ~/.bashrc && npm install -g @angular/cli 
#RUN source ~/.bashrc && install .

# OPTIONAL DEPLOYMENT EXAMPLE:
#-----------------------------
## Make App folder, copy project into container
# RUN mkdir -p /app
# WORKDIR /app
# COPY . .

## Install project requirements, build project
# RUN dnf install httpd -y; rm -rf /var/cache
# RUN ng build
# RUN cp -r ./dist/*/browser/* /var/www/html/

# RUN <<EOF cat >> /var/www/.htaccess
# RewriteEngine On
# # If an existing asset or directory is requested go to it as it is
# RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} -f [OR]
# RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} -d
# RewriteRule ^ - [L]
# # If the requested resource doesn't exist, use index.html
# RewriteRule ^ /index.html
# EOF
# WORKDIR /app

## Expose port and run app
# EXPOSE 8080
# CMD [ "httpd", "-DFOREGROUND" ]