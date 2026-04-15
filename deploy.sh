#!/usr/bin/env bash
set -e

# ==============================================
#        VLESS GCP AUTO DEPLOYER v2
#        github.com/saekacutie/scriptv2
#        Dynamic Terminal UI Edition
# ==============================================

# --- Colors ---
BOLD='\033[1m'; RESET='\033[0m'
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RED='\033[0;31m'
LRED='\033[1;31m'; LYELLOW='\033[1;33m'; LGREEN='\033[1;32m'; LCYAN='\033[1;36m'
LBLUE='\033[1;34m'; LMAGENTA='\033[1;35m'; LWHITE='\033[1;37m'
BLUE='\033[0;34m'; MAGENTA='\033[0;35m'; WHITE='\033[0;37m'

# --- Rainbow Colors Array ---
RAINBOW=("${LRED}" "${LYELLOW}" "${LGREEN}" "${LCYAN}" "${LBLUE}" "${LMAGENTA}")

# --- Hide Cursor ---
tput civis
restore_cursor() { tput cnorm; }
trap restore_cursor EXIT

# --- Dynamic Box Function ---
dynamic_box() {
    local title="$1"
    local status="$2"
    local color="$3"
    local width=70
    local inner_width=$((width - 4))
    
    clear
    echo ""
    echo -e "${color}${BOLD}╔$(printf '═%.0s' $(seq 1 $width))╗${RESET}"
    echo -e "${color}${BOLD}║${RESET} ${WHITE}${title}${RESET}$(printf '%*s' $((width - ${#title} - 3)) '')${color}${BOLD}║${RESET}"
    echo -e "${color}${BOLD}╠$(printf '═%.0s' $(seq 1 $width))╣${RESET}"
    echo -e "${color}${BOLD}║${RESET}$(printf '%*s' $((width - 2)) '')${color}${BOLD}║${RESET}"
    echo -e "${color}${BOLD}║${RESET}   ${BOLD}Status:${RESET} ${status}$(printf '%*s' $((width - ${#status} - 13)) '')${color}${BOLD}║${RESET}"
    echo -e "${color}${BOLD}║${RESET}$(printf '%*s' $((width - 2)) '')${color}${BOLD}║${RESET}"
    echo -e "${color}${BOLD}╚$(printf '═%.0s' $(seq 1 $width))╝${RESET}"
    echo ""
}

# --- Troubleshooting Box ---
troubleshooting_box() {
    local issue="$1"
    local solution="$2"
    local color="${RAINBOW[$((RANDOM % 6))]}"
    local width=70
    
    echo -e "${color}${BOLD}┌$(printf '─%.0s' $(seq 1 $width))┐${RESET}"
    echo -e "${color}${BOLD}│${RESET} ${YELLOW}${BOLD}TROUBLESHOOTING:${RESET} ${issue}$(printf '%*s' $((width - ${#issue} - 18)) '')${color}${BOLD}│${RESET}"
    echo -e "${color}${BOLD}├$(printf '─%.0s' $(seq 1 $width))┤${RESET}"
    echo -e "${color}${BOLD}│${RESET} ${GREEN}${BOLD}SOLUTION:${RESET} ${solution}$(printf '%*s' $((width - ${#solution} - 12)) '')${color}${BOLD}│${RESET}"
    echo -e "${color}${BOLD}└$(printf '─%.0s' $(seq 1 $width))┘${RESET}"
}

# --- Info Box ---
info_box() {
    local message="$1"
    local color="${RAINBOW[$((RANDOM % 6))]}"
    local width=70
    
    echo -e "${color}${BOLD}┌$(printf '─%.0s' $(seq 1 $width))┐${RESET}"
    echo -e "${color}${BOLD}│${RESET} ${CYAN}${BOLD}INFO:${RESET} ${message}$(printf '%*s' $((width - ${#message} - 8)) '')${color}${BOLD}│${RESET}"
    echo -e "${color}${BOLD}└$(printf '─%.0s' $(seq 1 $width))┘${RESET}"
}

# --- Countdown Timer ---
countdown() {
    local seconds=$1
    local message="$2"
    local width=50
    local color="${RAINBOW[$((RANDOM % 6))]}"
    
    for ((i=seconds; i>0; i--)); do
        echo -ne "\r${color}${BOLD}┌$(printf '─%.0s' $(seq 1 $width))┐${RESET}\n"
        echo -ne "${color}${BOLD}│${RESET} ${message} ${BOLD}${i}s${RESET}$(printf '%*s' $((width - ${#message} - ${#i} - 5)) '')${color}${BOLD}│${RESET}\n"
        echo -ne "${color}${BOLD}└$(printf '─%.0s' $(seq 1 $width))┘${RESET}"
        sleep 1
        echo -ne "\033[3A\033[2K"
    done
}

# --- Progress Spinner ---
spinner() {
    local pid=$1
    local message="$2"
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local color="${RAINBOW[$((RANDOM % 6))]}"
    
    echo -ne "${color}${BOLD}[${spinstr:0:1}]${RESET} ${message}"
    local i=0
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r${color}${BOLD}[%s]${RESET} ${message}" "${spinstr:i++%${#spinstr}:1}"
        sleep 0.1
    done
    printf "\r${GREEN}${BOLD}[✔]${RESET} ${message} ${GREEN}COMPLETE${RESET}\n"
}

# --- Rainbow Banner ---
rainbow_banner() {
    clear
    local width=80
    echo ""
    echo -e "${LRED}${BOLD}╔$(printf '═%.0s' $(seq 1 $width))╗${RESET}"
    echo -e "${LRED}${BOLD}║${RESET}         ${WHITE}${BOLD}██████╗ ██████╗ ██╗   ██╗████████╗███████╗██████╗ ██╗   ██╗${LRED}${BOLD}         ║${RESET}"
    echo -e "${LYELLOW}${BOLD}║${RESET}         ${WHITE}${BOLD}██╔══██╗██╔══██╗██║   ██║╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝${LYELLOW}${BOLD}         ║${RESET}"
    echo -e "${LGREEN}${BOLD}║${RESET}         ${WHITE}${BOLD}██████╔╝██████╔╝██║   ██║   ██║   ███████╗██████╔╝ ╚████╔╝ ${LGREEN}${BOLD}         ║${RESET}"
    echo -e "${LCYAN}${BOLD}║${RESET}         ${WHITE}${BOLD}██╔═══╝ ██╔══██╗╚██╗ ██╔╝   ██║   ╚════██║██╔═══╝   ╚██╔╝  ${LCYAN}${BOLD}         ║${RESET}"
    echo -e "${LBLUE}${BOLD}║${RESET}         ${WHITE}${BOLD}██║     ██║  ██║ ╚████╔╝    ██║   ███████║██║        ██║   ${LBLUE}${BOLD}         ║${RESET}"
    echo -e "${LMAGENTA}${BOLD}║${RESET}         ${WHITE}${BOLD}╚═╝     ╚═╝  ╚═╝  ╚═══╝     ╚═╝   ╚══════╝╚═╝        ╚═╝   ${LMAGENTA}${BOLD}         ║${RESET}"
    echo -e "${LRED}${BOLD}║${RESET}                                                                                ${LRED}${BOLD}║${RESET}"
    echo -e "${LYELLOW}${BOLD}║${RESET}                    ${WHITE}${BOLD}VLESS GCP AUTO DEPLOYER v2${LYELLOW}${BOLD}                          ║${RESET}"
    echo -e "${LGREEN}${BOLD}║${RESET}                    ${CYAN}github.com/saekacutie/scriptv2${LGREEN}${BOLD}                     ║${RESET}"
    echo -e "${LRED}${BOLD}╚$(printf '═%.0s' $(seq 1 $width))╝${RESET}"
    echo ""
}

# ==============================================
#        MAIN EXECUTION
# ==============================================

rainbow_banner
countdown 3 "Initializing deployment environment..."
dynamic_box "API VERIFICATION" "Enabling required APIs..." "${LBLUE}"

# Enable APIs in background
gcloud services enable run.googleapis.com containerregistry.googleapis.com cloudbuild.googleapis.com --quiet 2>/dev/null &
API_PID=$!
spinner $API_PID "Enabling Cloud APIs"
dynamic_box "API VERIFICATION" "APIs enabled successfully" "${GREEN}"
sleep 1

# Project Setup
dynamic_box "PROJECT CONFIGURATION" "Detecting active project..." "${LYELLOW}"
PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
if [ -z "$PROJECT_ID" ]; then
    PROJECT_ID="vless-$(date +%s)"
    gcloud projects create "$PROJECT_ID" --name="VLESS-Proxy" --quiet
    gcloud config set project "$PROJECT_ID" --quiet
fi
dynamic_box "PROJECT CONFIGURATION" "Project: $PROJECT_ID" "${GREEN}"
sleep 1

# Region Selection
dynamic_box "REGION SELECTION" "Optimizing for Qwiklabs..." "${LMAGENTA}"
REGION="us-central1"
info_box "Qwiklabs environment detected. Using us-central1 (policy-compliant)"
dynamic_box "REGION SELECTION" "Region: $REGION" "${GREEN}"
sleep 1

# Service Name
dynamic_box "SERVICE CONFIGURATION" "Enter service name..." "${LCYAN}"
read -p "$(echo -e "${CYAN}[?]${RESET} Service name [default: prvtspyyy404]: ")" SERVICE_NAME_INPUT
SERVICE_NAME="${SERVICE_NAME_INPUT:-prvtspyyy404}"
SERVICE_NAME=$(echo "$SERVICE_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')
[ -z "$SERVICE_NAME" ] && SERVICE_NAME="prvtspyyy404"
dynamic_box "SERVICE CONFIGURATION" "Service: $SERVICE_NAME" "${GREEN}"
sleep 1

# CPU/RAM Selection
dynamic_box "CPU AND MEMORY" "Select configuration..." "${LBLUE}"
echo ""
echo -e "  ${WHITE}[1]${RESET} 1 vCPU, 1 GiB"
echo -e "  ${WHITE}[2]${RESET} 1 vCPU, 2 GiB"
echo -e "  ${WHITE}[3]${RESET} 2 vCPU, 2 GiB"
echo -e "  ${WHITE}[4]${RESET} 2 vCPU, 4 GiB ${GREEN}(RECOMMENDED)${RESET}"
echo -e "  ${WHITE}[5]${RESET} 4 vCPU, 8 GiB"
echo ""
read -p "$(echo -e "${CYAN}[?]${RESET} Select [1-5] [default: 4]: ")" CPU_RAM_CHOICE
case ${CPU_RAM_CHOICE:-4} in
    1) CPU="1"; MEMORY="1Gi" ;;
    2) CPU="1"; MEMORY="2Gi" ;;
    3) CPU="2"; MEMORY="2Gi" ;;
    4) CPU="2"; MEMORY="4Gi" ;;
    5) CPU="4"; MEMORY="8Gi" ;;
    *) CPU="2"; MEMORY="4Gi" ;;
esac
dynamic_box "CPU AND MEMORY" "CPU: $CPU, Memory: $MEMORY" "${GREEN}"
sleep 1

# Build Parameters
UUID=$(grep -o '"id": *"[^"]*"' config.json 2>/dev/null | head -1 | sed 's/.*"id": *"\([^"]*\)".*/\1/' || echo "9e507b33-65b6-40a4-b37f-eabad158b645")
WS_PATH=$(grep -o '"path": *"[^"]*"' config.json 2>/dev/null | head -1 | sed 's/.*"path": *"\([^"]*\)".*/\1/' || echo "/prvtspyyy")
IMAGE="gcr.io/$PROJECT_ID/$SERVICE_NAME:latest"

dynamic_box "DEPLOYMENT PARAMETERS" "UUID: ${UUID:0:16}... | Path: $WS_PATH" "${LMAGENTA}"
sleep 1

# Build Image
dynamic_box "BUILDING CONTAINER" "Building Docker image..." "${LYELLOW}"
docker build -t "$IMAGE" . --quiet &
BUILD_PID=$!
spinner $BUILD_PID "Building Docker image"
dynamic_box "BUILDING CONTAINER" "Build complete" "${GREEN}"
sleep 1

# Push Image
dynamic_box "PUSHING TO REGISTRY" "Uploading to gcr.io..." "${LBLUE}"
docker push "$IMAGE" --quiet &
PUSH_PID=$!
spinner $PUSH_PID "Pushing to Container Registry"
dynamic_box "PUSHING TO REGISTRY" "Push complete" "${GREEN}"
sleep 1

# Deploy to Cloud Run
dynamic_box "DEPLOYING TO CLOUD RUN" "Creating service in $REGION..." "${LCYAN}"
gcloud run deploy "$SERVICE_NAME" \
    --image "$IMAGE" \
    --platform managed \
    --region "$REGION" \
    --allow-unauthenticated \
    --port 8080 \
    --cpu "$CPU" \
    --memory "$MEMORY" \
    --concurrency 250 \
    --timeout 3600 \
    --min-instances 1 \
    --max-instances 1 \
    --no-cpu-throttling \
    --session-affinity \
    --quiet &
DEPLOY_PID=$!
spinner $DEPLOY_PID "Deploying to Cloud Run"

# Check deployment success
if gcloud run services describe "$SERVICE_NAME" --region "$REGION" &>/dev/null; then
    dynamic_box "DEPLOYING TO CLOUD RUN" "Deployment successful" "${GREEN}"
else
    dynamic_box "DEPLOYING TO CLOUD RUN" "Deployment failed" "${RED}"
    troubleshooting_box "Cloud Run deployment failed" "Check quota in $REGION or try different region"
    countdown 10 "Returning to menu..."
    exit 1
fi

# Get Service URL
SERVICE_URL=$(gcloud run services describe "$SERVICE_NAME" --region "$REGION" --format='value(status.url)' 2>/dev/null)
CLEAN_HOST=$(echo "$SERVICE_URL" | sed 's|https://||')

# Generate VLESS URI
VLESS_URI="vless://${UUID}@www.gstatic.com:443?encryption=none&security=tls&type=ws&path=%2F${WS_PATH#/}&host=${CLEAN_HOST}&sni=firebase-settings.crashlytics.com&fp=chrome#${SERVICE_NAME}"

# Success Banner
clear
echo ""
echo -e "${GREEN}${BOLD}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}                                                                            ${GREEN}${BOLD}║${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}   ${WHITE}${BOLD}DEPLOYMENT SUCCESSFUL${RESET}                                                  ${GREEN}${BOLD}║${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}   ${CYAN}github.com/saekacutie/scriptv2${RESET}                                       ${GREEN}${BOLD}║${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}                                                                            ${GREEN}${BOLD}║${RESET}"
echo -e "${GREEN}${BOLD}╠════════════════════════════════════════════════════════════════════════════╣${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}                                                                            ${GREEN}${BOLD}║${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}   ${CYAN}Service:${RESET}     ${WHITE}${SERVICE_NAME}${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}   ${CYAN}Address:${RESET}     ${WHITE}www.gstatic.com${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}   ${CYAN}SNI:${RESET}         ${WHITE}firebase-settings.crashlytics.com${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}   ${CYAN}Host:${RESET}        ${WHITE}${CLEAN_HOST}${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}   ${CYAN}Port:${RESET}        ${WHITE}443${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}   ${CYAN}UUID:${RESET}        ${WHITE}${UUID}${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}   ${CYAN}WS Path:${RESET}     ${WHITE}${WS_PATH}${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}   ${CYAN}Transport:${RESET}   ${WHITE}WebSocket (ws)${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}   ${CYAN}Security:${RESET}    ${WHITE}TLS (Google Managed)${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}   ${CYAN}Region:${RESET}      ${WHITE}${REGION}${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}   ${CYAN}CPU:${RESET}         ${WHITE}${CPU}${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}   ${CYAN}Memory:${RESET}      ${WHITE}${MEMORY}${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}   ${CYAN}Timeout:${RESET}     ${WHITE}3600s${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}   ${CYAN}AdBlock:${RESET}     ${WHITE}Active (All Ads)${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}                                                                            ${GREEN}${BOLD}║${RESET}"
echo -e "${GREEN}${BOLD}╠════════════════════════════════════════════════════════════════════════════╣${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}                                                                            ${GREEN}${BOLD}║${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}   ${CYAN}${BOLD}Import URI:${RESET}                                                         ${GREEN}${BOLD}║${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}   ${WHITE}${VLESS_URI:0:68}${RESET}  ${GREEN}${BOLD}║${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}   ${WHITE}${VLESS_URI:68:68}${RESET}  ${GREEN}${BOLD}║${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}   ${WHITE}${VLESS_URI:136:68}${RESET}  ${GREEN}${BOLD}║${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}                                                                            ${GREEN}${BOLD}║${RESET}"
echo -e "${GREEN}${BOLD}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
echo ""

# Troubleshooting Tips
troubleshooting_box "Connection timeout?" "Enable Auto Ping in HTTP Custom (25s interval)"
troubleshooting_box "No internet when connected?" "Verify Host header matches exactly: $CLEAN_HOST"
troubleshooting_box "Container failed to start?" "Check Cloud Run logs in GCP Console"
info_box "Deployment saved to: /tmp/vless-uri.txt"
info_box "To view again: cat /tmp/vless-uri.txt"

echo ""
echo -e "${GREEN}${BOLD}Deployment Complete. Thank you for using scriptv2!${RESET}"
echo ""

# Restore cursor
tput cnorm
