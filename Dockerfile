FROM guacamole/guacamole:latest

# تثبيت guacd وxrdp وXFCE
RUN apt-get update && apt-get install -y \
    guacd \
    xrdp \
    xfce4 \
    xfce4-goodies \
    && rm -rf /var/lib/apt/lists/*

# إعداد Guacamole
ENV GUACAMOLE_HOME="/etc/guacamole"
COPY user-mapping.xml /etc/guacamole/user-mapping.xml

# إعداد xrdp
RUN echo "xfce4-session" > /etc/xrdp/startwm.sh \
    && chmod +x /etc/xrdp/startwm.sh \
    && sed -i 's/3389/3389/' /etc/xrdp/xrdp.ini

# إعداد مستخدم RDP
RUN useradd -m -s /bin/bash rdpuser \
    && echo "rdpuser:rdppassword" | chpasswd

# تعريض المنافذ
EXPOSE 8080 3389

# تشغيل الخدمات
CMD service guacd start && service xrdp start && /opt/guacamole/bin/start.sh
