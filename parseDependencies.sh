#!/bin/bash

# Directory containing all Swift packages
MODULES_DIR="./Modules"

# Output file for the combined Mermaid graph
GLOBAL_GRAPH_FILE="./PackageDependencies.md"

# Initialize the global graph file with the Mermaid header
echo "mermaid" > "$GLOBAL_GRAPH_FILE"
echo "graph TD;" >> "$GLOBAL_GRAPH_FILE"

# Loop through all module directories and append their graphs
for MODULE in "$MODULES_DIR"/*; do
    if [ -d "$MODULE" ]; then
        MODULE_NAME=$(basename "$MODULE")
        MODULE_GRAPH_FILE="$MODULE/PackageDependencies.md"

        if [ -f "$MODULE_GRAPH_FILE" ]; then
            # Start a subgraph for the current module
            echo "" >> "$GLOBAL_GRAPH_FILE"
            echo "subgraph $MODULE_NAME" >> "$GLOBAL_GRAPH_FILE"
            
            # Extract the content of the module's Mermaid graph (excluding the `graph TD;` line)
            # tail -n +2 "$MODULE_GRAPH_FILE" >> "$GLOBAL_GRAPH_FILE"
            sed '1,2d;$d' "$MODULE_GRAPH_FILE" >> "$GLOBAL_GRAPH_FILE"
            
            # End the subgraph
            echo "end" >> "$GLOBAL_GRAPH_FILE"
        fi
    fi
done

# Finalize the Mermaid graph
echo "" >> "$GLOBAL_GRAPH_FILE"

echo "Global dependency graph has been created: $GLOBAL_GRAPH_FILE"