FROM ibmjava:sfj-alpine

ARG RAT_VERSION="0.13"
ARG APACHE_MIRROR="https://www-us.apache.org/dist"


SHELL ["/bin/sh", "-e", "-x", "-c"]

# We don't download the KEYS file, but instead pre-bake them, so that any
# change to approved keys needs a manual approval. Rat is released fairly
# infrequently so this shouldn't be too onerous
RUN apk add -U --no-cache --virtual .build-deps \
        gnupg \ 
        unzip \
    && gpg --recv-key 0x33c67755184053ec2d26e10727cce8f1b1313de2 \
                      0xb920d295bf0e61cb4cf0896c33cd6733af5ec452 \
                      0x2ce6302b944f8492ca763ff3843ddb767188601c \
                      0x6bfab2e3c6490b421b25c76c9c8c892f91f8e6d1 \
    && dist_name="apache-rat-${RAT_VERSION}" \
    && rat_tgz="${dist_name}-bin.tar.gz" \
    && wget -T 30 "${APACHE_MIRROR}/creadur/${dist_name}/${rat_tgz}.asc" \
    && wget -T 30 "${APACHE_MIRROR}/creadur/${dist_name}/${rat_tgz}" \
    && gpg --verify "${rat_tgz}.asc" "${rat_tgz}" \
    && tar --extract --gzip --file "${rat_tgz}" --strip-components=1 "${dist_name}/${dist_name}.jar" "${dist_name}/LICENSE" \
    && rm -vrf "${rat_tgz}" "${rat_tgz}.asc" \
    && ln -s "${dist_name}.jar" "apache-rat.jar" \
    && apk del .build-deps \
    && rm -rf ~/.gnupg

ENTRYPOINT ["java", "-jar", "apache-rat.jar" ]

CMD ["--help"]
