#!/bin/bash

echo "🔧 Fixing deprecated Kustomize syntax..."

# Find all kustomization.yaml files and run fix command
find . -name "kustomization.yaml" -type f | while read -r file; do
    dir=$(dirname "$file")
    echo "Fixing: $dir"
    cd "$dir" && kustomize edit fix && cd - > /dev/null
done

echo "✅ All kustomization files fixed!"