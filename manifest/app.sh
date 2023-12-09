cat > app.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-deployment
  labels: 
    app: app
spec:
  replicas: 3
  selector: 
    matchLabels:
      app: app
  template:
    metadata: 
      labels:
        app: app
    spec:
      containers:
      - name: app
        image: $DOCKER_USERNAME/app:latest
        ports:
        - containerPort: 9000
EOF