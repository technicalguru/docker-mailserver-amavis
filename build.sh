docker buildx build \
     --progress=plain \
     -t technicalguru/mailserver-amavis:latest \
     -t technicalguru/mailserver-amavis:2.13.0.3 \
     -t technicalguru/mailserver-amavis:2.13.0 \
     -t technicalguru/mailserver-amavis:2.13 \
     -t technicalguru/mailserver-amavis:2 \
     --push \
     --platform linux/amd64,linux/arm64 \

#docker build --progress=plain -t technicalguru/mailserver-amavis:latest .
