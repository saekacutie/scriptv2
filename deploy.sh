#!/usr/bin/env bash
set -e

# ==============================================
#        VLESS GCP AUTO DEPLOYER v2
#        github.com/saekacutie/scriptv2
# ==============================================

# --- Colors ---
BOLD='\033[1m'; RESET='\033[0m'
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RED='\033[0;31m'
LRED='\033[1;31m'; LYELLOW='\033[1;33m'; LGREEN='\033[1;32m'; LCYAN='\033[1;36m'; LBLUE='\033[1;34m'; LMAGENTA='\033[1;35m'; LWHITE='\033[1;37m'

C_SUCCESS="${BOLD}${LGREEN}"; C_ERROR="${BOLD}${LRED}"; C_WARN="${BOLD}${LYELLOW}"
C_INFO="${BOLD}${LCYAN}"; C_HEADER="${BOLD}${LMAGENTA}"; C_ACCENT="${BOLD}${LBLUE}"; C_PLAIN="${BOLD}${WHITE}"

math_bold() { echo "$1" | sed -e 's/A/𝗔/g' -e 's/B/𝗕/g' -e 's/C/𝗖/g' -e 's/D/𝗗/g' -e 's/E/𝗘/g' -e 's/F/𝗙/g' -e 's/G/𝗚/g' -e 's/H/𝗛/g' -e 's/I/𝗜/g' -e 's/J/𝗝/g' -e 's/K/𝗞/g' -e 's/L/𝗟/g' -e 's/M/𝗠/g' -e 's/N/𝗡/g' -e 's/O/𝗢/g' -e 's/P/𝗣/g' -e 's/Q/𝗤/g' -e 's/R/𝗥/g' -e 's/S/𝗦/g' -e 's/T/𝗧/g' -e 's/U/𝗨/g' -e 's/V/𝗩/g' -e 's/W/𝗪/g' -e 's/X/𝗫/g' -e 's/Y/𝗬/g' -e 's/Z/𝗭/g' -e 's/0/𝟬/g' -e 's/1/𝟭/g' -e 's/2/𝟮/g' -e 's/3/𝟯/g' -e 's/4/𝟰/g' -e 's/5/𝟱/g' -e 's/6/𝟲/g' -e 's/7/𝟳/g' -e 's/8/𝟴/g' -e 's/9/𝟵/g'; }

rainbow_banner() {
    clear
    echo -e "${BOLD}${LRED}╔══════════════════════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}${LRED}║${RESET}         ${BOLD}${WHITE}██████╗ ██████╗ ██╗   ██╗████████╗███████╗██████╗ ██╗   ██╗${LRED}         ${BOLD}${LRED}║${RESET}"
    echo -e "${BOLD}${LRED}║${RESET}         ${BOLD}${WHITE}██╔══██╗██╔══██╗██║   ██║╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝${LRED}         ${BOLD}${LRED}║${RESET}"
    echo -e "${BOLD}${LRED}║${RESET}         ${BOLD}${WHITE}██████╔╝██████╔╝██║   ██║   ██║   ███████╗██████╔╝ ╚████╔╝ ${LRED}         ${BOLD}${LRED}║${RESET}"
    echo -e "${BOLD}${LRED}║${RESET}         ${BOLD}${WHITE}██╔═══╝ ██╔══██╗╚██╗ ██╔╝   ██║   ╚════██║██╔═══╝   ╚██╔╝  ${LRED}         ${BOLD}${LRED}║${RESET}"
    echo -e "${BOLD}${LRED}║${RESET}         ${BOLD}${WHITE}██║     ██║  ██║ ╚████╔╝    ██║   ███████║██║        ██║   ${LRED}         ${BOLD}${LRED}║${RESET}"
    echo -e "${BOLD}${LRED}║${RESET}         ${BOLD}${WHITE}╚═╝     ╚═╝  ╚═╝  ╚═══╝     ╚═╝   ╚══════╝╚═╝        ╚═╝   ${LRED}         ${BOLD}${LRED}║${RESET}"
    echo -e "${BOLD}${LRED}║${RESET}                                                                                ${BOLD}${LRED}║${RESET}"
    echo -e "${BOLD}${LRED}║${RESET}                    ${BOLD}${WHITE}VLESS GCP AUTO DEPLOYER v2${RESET}                          ${BOLD}${LRED}║${RESET}"
    echo -e "${BOLD}${LRED}║${RESET}                    ${CYAN}github.com/saekacutie/scriptv2${RESET}                     ${BOLD}${LRED}║${RESET}"
    echo -e "${BOLD}${LRED}║${RESET}                                                                                ${BOLD}${LRED}║${RESET}"
    echo -e "${BOLD}${LRED}╚══════════════════════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
}

rainbow_banner

# --- Fast API Verification (Parallel) ---
echo -e "${C_HEADER}════════════════════════════════════════════════════════════════════════════${RESET}"
echo -e "${C_PLAIN}$(math_bold "API VERIFICATION")${RESET}"
echo -e "${C_HEADER}════════════════════════════════════════════════════════════════════════════${RESET}"

gcloud services enable run.googleapis.com containerregistry.googleapis.com cloudbuild.googleapis.com --quiet 2>/dev/null &
API_PID=$!
echo -e "${C_INFO}[*]${RESET} Enabling required APIs..."
wait $API_PID
echo -e "${C_SUCCESS}[✔]${RESET} APIs ready"
echo -e "${C_HEADER}════════════════════════════════════════════════════════════════════════════${RESET}"
echo ""

# --- Project Setup ---
PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
if [ -z "$PROJECT_ID" ]; then
    echo -e "${C_WARN}[!]${RESET} No project set. Creating..."
    PROJECT_ID="vless-$(date +%s)"
    gcloud projects create "$PROJECT_ID" --name="VLESS-Proxy" --quiet
    gcloud config set project "$PROJECT_ID" --quiet
fi
echo -e "${C_SUCCESS}[✔]${RESET} Project: ${BOLD}${PROJECT_ID}${RESET}"
echo ""

# --- Automatic Region (Qwiklabs Safe) ---
echo -e "${C_HEADER}════════════════════════════════════════════════════════════════════════════${RESET}"
echo -e "${C_PLAIN}$(math_bold "REGION SELECTION")${RESET}"
echo -e "${C_HEADER}════════════════════════════════════════════════════════════════════════════${RESET}"
REGION="us-central1"
echo -e "${C_SUCCESS}[✔]${RESET} Selected region: ${BOLD}${REGION}${RESET} (Qwiklabs Optimized)"
echo -e "${C_HEADER}════════════════════════════════════════════════════════════════════════════${RESET}"
echo ""

# --- Service Name ---
echo -e "${C_HEADER}════════════════════════════════════════════════════════════════════════════${RESET}"
echo -e "${C_PLAIN}$(math_bold "SERVICE CONFIGURATION")${RESET}"
echo -e "${C_HEADER}════════════════════════════════════════════════════════════════════════════${RESET}"
read -p "$(echo -e "${C_INFO}[?]${RESET} Enter service name [default: prvtspyyy404]: ")" SERVICE_NAME_INPUT
SERVICE_NAME="${SERVICE_NAME_INPUT:-prvtspyyy404}"
SERVICE_NAME=$(echo "$SERVICE_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')
[ -z "$SERVICE_NAME" ] && SERVICE_NAME="prvtspyyy404"
echo -e "${C_SUCCESS}[✔]${RESET} Service name: ${BOLD}${SERVICE_NAME}${RESET}"
echo -e "${C_HEADER}════════════════════════════════════════════════════════════════════════════${RESET}"
echo ""

# --- CPU/RAM Selection ---
echo -e "${C_HEADER}════════════════════════════════════════════════════════════════════════════${RESET}"
echo -e "${C_PLAIN}$(math_bold "CPU AND MEMORY")${RESET}"
echo -e "${C_HEADER}════════════════════════════════════════════════════════════════════════════${RESET}"
echo -e "  ${C_ACCENT}[1]${RESET} 1 vCPU, 1 GiB"
echo -e "  ${C_ACCENT}[2]${RESET} 1 vCPU, 2 GiB"
echo -e "  ${C_ACCENT}[3]${RESET} 2 vCPU, 2 GiB"
echo -e "  ${C_ACCENT}[4]${RESET} 2 vCPU, 4 GiB ${GREEN}(RECOMMENDED)${RESET}"
echo -e "  ${C_ACCENT}[5]${RESET} 4 vCPU, 8 GiB"
read -p "$(echo -e "${C_INFO}[?]${RESET} Select [1-5] [default: 4]: ")" CPU_RAM_CHOICE
case ${CPU_RAM_CHOICE:-4} in
    1) CPU="1"; MEMORY="1Gi" ;;
    2) CPU="1"; MEMORY="2Gi" ;;
    3) CPU="2"; MEMORY="2Gi" ;;
    4) CPU="2"; MEMORY="4Gi" ;;
    5) CPU="4"; MEMORY="8Gi" ;;
    *) CPU="2"; MEMORY="4Gi" ;;
esac
echo -e "${C_SUCCESS}[✔]${RESET} CPU: ${BOLD}${CPU}${RESET}, Memory: ${BOLD}${MEMORY}${RESET}"
echo -e "${C_HEADER}════════════════════════════════════════════════════════════════════════════${RESET}"
echo ""

# --- Build Parameters ---
UUID=$(grep -o '"id": *"[^"]*"' config.json 2>/dev/null | head -1 | sed 's/.*"id": *"\([^"]*\)".*/\1/' || echo "9e507b33-65b6-40a4-b37f-eabad158b645")
WS_PATH=$(grep -o '"path": *"[^"]*"' config.json 2>/dev/null | head -1 | sed 's/.*"path": *"\([^"]*\)".*/\1/' || echo "/prvtspyyy")
IMAGE="gcr.io/$PROJECT_ID/$SERVICE_NAME:latest"

echo -e "${C_HEADER}════════════════════════════════════════════════════════════════════════════${RESET}"
echo -e "${C_PLAIN}$(math_bold "DEPLOYMENT PARAMETERS")${RESET}"
echo -e "${C_HEADER}════════════════════════════════════════════════════════════════════════════${RESET}"
echo -e "${C_ACCENT}UUID:${RESET}     ${BOLD}${UUID}${RESET}"
echo -e "${C_ACCENT}WS Path:${RESET}   ${BOLD}${WS_PATH}${RESET}"
echo -e "${C_ACCENT}Region:${RESET}    ${BOLD}${REGION}${RESET}"
echo -e "${C_ACCENT}CPU:${RESET}       ${BOLD}${CPU}${RESET}"
echo -e "${C_ACCENT}Memory:${RESET}    ${BOLD}${MEMORY}${RESET}"
echo -e "${C_HEADER}════════════════════════════════════════════════════════════════════════════${RESET}"
echo ""

# --- Build and Deploy (Optimized) ---
echo -e "${C_HEADER}════════════════════════════════════════════════════════════════════════════${RESET}"
echo -e "${C_PLAIN}$(math_bold "BUILDING AND DEPLOYING")${RESET}"
echo -e "${C_HEADER}════════════════════════════════════════════════════════════════════════════${RESET}"

echo -e "${C_INFO}[*]${RESET} Building image..."
docker build -t "$IMAGE" . --quiet
echo -e "${C_SUCCESS}[✔]${RESET} Build complete"

echo -e "${C_INFO}[*]${RESET} Pushing to registry..."
docker push "$IMAGE" --quiet
echo -e "${C_SUCCESS}[✔]${RESET} Push complete"

echo -e "${C_INFO}[*]${RESET} Deploying to Cloud Run..."
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
    --quiet

SERVICE_URL=$(gcloud run services describe "$SERVICE_NAME" --region "$REGION" --format='value(status.url)' 2>/dev/null)
CLEAN_HOST=$(echo "$SERVICE_URL" | sed 's|https://||')

# --- VLESS URI ---
VLESS_URI="vless://${UUID}@www.gstatic.com:443?encryption=none&security=tls&type=ws&path=%2F${WS_PATH#/}&host=${CLEAN_HOST}&sni=firebase-settings.crashlytics.com&fp=chrome#${SERVICE_NAME}"

# --- Success Banner ---
echo ""
echo -e "${C_SUCCESS}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${C_SUCCESS}║${RESET}                                                                            ${C_SUCCESS}║${RESET}"
echo -e "${C_SUCCESS}║${RESET}   ${BOLD}${WHITE}$(math_bold "DEPLOYMENT SUCCESSFUL")${RESET}                                          ${C_SUCCESS}║${RESET}"
echo -e "${C_SUCCESS}║${RESET}   ${C_ACCENT}github.com/saekacutie/scriptv2${RESET}                                   ${C_SUCCESS}║${RESET}"
echo -e "${C_SUCCESS}║${RESET}                                                                            ${C_SUCCESS}║${RESET}"
echo -e "${C_SUCCESS}╠════════════════════════════════════════════════════════════════════════════╣${RESET}"
echo -e "${C_SUCCESS}║${RESET}                                                                            ${C_SUCCESS}║${RESET}"
echo -e "${C_SUCCESS}║${RESET}   ${C_ACCENT}Service:${RESET}     ${BOLD}${SERVICE_NAME}${RESET}"
echo -e "${C_SUCCESS}║${RESET}   ${C_ACCENT}Address:${RESET}     ${BOLD}www.gstatic.com${RESET}"
echo -e "${C_SUCCESS}║${RESET}   ${C_ACCENT}SNI:${RESET}         ${BOLD}firebase-settings.crashlytics.com${RESET}"
echo -e "${C_SUCCESS}║${RESET}   ${C_ACCENT}Host:${RESET}        ${BOLD}${CLEAN_HOST}${RESET}"
echo -e "${C_SUCCESS}║${RESET}   ${C_ACCENT}Port:${RESET}        ${BOLD}443${RESET}"
echo -e "${C_SUCCESS}║${RESET}   ${C_ACCENT}UUID:${RESET}        ${BOLD}${UUID}${RESET}"
echo -e "${C_SUCCESS}║${RESET}   ${C_ACCENT}WS Path:${RESET}     ${BOLD}${WS_PATH}${RESET}"
echo -e "${C_SUCCESS}║${RESET}   ${C_ACCENT}Transport:${RESET}   ${BOLD}WebSocket (ws)${RESET}"
echo -e "${C_SUCCESS}║${RESET}   ${C_ACCENT}Security:${RESET}    ${BOLD}TLS (Google Managed)${RESET}"
echo -e "${C_SUCCESS}║${RESET}   ${C_ACCENT}Region:${RESET}      ${BOLD}${REGION}${RESET}"
echo -e "${C_SUCCESS}║${RESET}   ${C_ACCENT}CPU:${RESET}         ${BOLD}${CPU}${RESET}"
echo -e "${C_SUCCESS}║${RESET}   ${C_ACCENT}Memory:${RESET}      ${BOLD}${MEMORY}${RESET}"
echo -e "${C_SUCCESS}║${RESET}   ${C_ACCENT}Timeout:${RESET}     ${BOLD}3600s${RESET}"
echo -e "${C_SUCCESS}║${RESET}                                                                            ${C_SUCCESS}║${RESET}"
echo -e "${C_SUCCESS}╠════════════════════════════════════════════════════════════════════════════╣${RESET}"
echo -e "${C_SUCCESS}║${RESET}                                                                            ${C_SUCCESS}║${RESET}"
echo -e "${C_SUCCESS}║${RESET}   ${C_PLAIN}Import URI:${RESET}                                                         ${C_SUCCESS}║${RESET}"
echo -e "${C_SUCCESS}║${RESET}   ${BOLD}${VLESS_URI}${RESET}  ${C_SUCCESS}║${RESET}"
echo -e "${C_SUCCESS}║${RESET}                                                                            ${C_SUCCESS}║${RESET}"
echo -e "${C_SUCCESS}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
echo ""
