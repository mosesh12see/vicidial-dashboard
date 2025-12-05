#!/bin/bash
################################################################################
# VICIdial White Label Deployment Script
#
# This script helps you backup your current VICIdial installation and
# deploy white label customizations safely.
#
# USAGE:
#   ./backup_and_deploy.sh [backup|deploy|rollback]
#
# IMPORTANT: Test in staging environment first!
################################################################################

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration - UPDATE THESE PATHS FOR YOUR SYSTEM
VICIDIAL_WEB_ROOT="/srv/www/htdocs"
BACKUP_DIR="/backup/vicidial_whitelabel"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
CURRENT_BACKUP="${BACKUP_DIR}/backup_${TIMESTAMP}"

# Database configuration
DB_HOST="localhost"
DB_USER="root"
DB_PASS=""  # Leave empty to prompt
DB_NAME="asterisk"

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo ""
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}============================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ ERROR: $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ WARNING: $1${NC}"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
       print_error "This script must be run as root (use sudo)"
       exit 1
    fi
}

check_paths() {
    if [ ! -d "$VICIDIAL_WEB_ROOT" ]; then
        print_error "VICIdial web root not found: $VICIDIAL_WEB_ROOT"
        exit 1
    fi
    print_success "VICIdial web root found: $VICIDIAL_WEB_ROOT"
}

################################################################################
# Backup Function
################################################################################

do_backup() {
    print_header "CREATING BACKUP"

    # Create backup directory
    mkdir -p "$CURRENT_BACKUP"
    print_success "Created backup directory: $CURRENT_BACKUP"

    # Backup web files
    print_warning "Backing up web files (this may take a few minutes)..."
    tar -czf "${CURRENT_BACKUP}/www_files.tar.gz" "$VICIDIAL_WEB_ROOT" 2>/dev/null
    print_success "Web files backed up"

    # Backup database
    print_warning "Backing up database..."
    if [ -z "$DB_PASS" ]; then
        mysqldump -u "$DB_USER" -p "$DB_NAME" > "${CURRENT_BACKUP}/database_backup.sql"
    else
        mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "${CURRENT_BACKUP}/database_backup.sql"
    fi
    print_success "Database backed up"

    # Backup Asterisk configs
    if [ -d "/etc/asterisk" ]; then
        tar -czf "${CURRENT_BACKUP}/asterisk_config.tar.gz" /etc/asterisk 2>/dev/null
        print_success "Asterisk configs backed up"
    fi

    # Backup Perl scripts
    if [ -d "/usr/share/astguiclient" ]; then
        tar -czf "${CURRENT_BACKUP}/astguiclient.tar.gz" /usr/share/astguiclient 2>/dev/null
        print_success "Perl scripts backed up"
    fi

    # Create manifest file
    cat > "${CURRENT_BACKUP}/BACKUP_MANIFEST.txt" << EOF
VICIdial White Label Backup
============================
Timestamp: $(date)
Backup Location: $CURRENT_BACKUP

Files Included:
- www_files.tar.gz (Web root: $VICIDIAL_WEB_ROOT)
- database_backup.sql (Database: $DB_NAME)
- asterisk_config.tar.gz (Asterisk configs)
- astguiclient.tar.gz (Perl scripts)

To Restore:
1. Extract web files: tar -xzf www_files.tar.gz -C /
2. Restore database: mysql -u root -p $DB_NAME < database_backup.sql
3. Extract asterisk configs: tar -xzf asterisk_config.tar.gz -C /
4. Extract perl scripts: tar -xzf astguiclient.tar.gz -C /
5. Restart services: systemctl restart apache2 && systemctl restart asterisk
EOF

    # Create symlink to latest backup
    ln -sfn "$CURRENT_BACKUP" "${BACKUP_DIR}/latest"

    print_success "Backup completed successfully!"
    print_success "Backup location: $CURRENT_BACKUP"
    print_success "Latest backup symlink: ${BACKUP_DIR}/latest"

    # Show backup size
    BACKUP_SIZE=$(du -sh "$CURRENT_BACKUP" | cut -f1)
    echo ""
    echo -e "${GREEN}Total backup size: $BACKUP_SIZE${NC}"
}

################################################################################
# Deploy Function
################################################################################

do_deploy() {
    print_header "DEPLOYING WHITE LABEL CUSTOMIZATIONS"

    # Safety check
    echo -e "${YELLOW}⚠️  WARNING: This will modify your VICIdial installation!${NC}"
    echo ""
    read -p "Have you created a backup? (yes/no): " backup_confirm
    if [ "$backup_confirm" != "yes" ]; then
        print_error "Please create a backup first using: $0 backup"
        exit 1
    fi

    echo ""
    read -p "Are you deploying to STAGING or PRODUCTION? " environment
    if [ "$environment" == "PRODUCTION" ]; then
        echo -e "${RED}⚠️  DEPLOYING TO PRODUCTION!${NC}"
        read -p "Type 'CONFIRM PRODUCTION' to continue: " confirm
        if [ "$confirm" != "CONFIRM PRODUCTION" ]; then
            print_error "Deployment cancelled"
            exit 1
        fi
    fi

    # Deploy logos
    print_warning "Step 1: Deploying logos..."
    if [ -f "your_agent_logo.gif" ]; then
        cp "your_agent_logo.gif" "${VICIDIAL_WEB_ROOT}/agc/images/vdc_tab_vicidial.gif"
        chmod 644 "${VICIDIAL_WEB_ROOT}/agc/images/vdc_tab_vicidial.gif"
        print_success "Agent logo deployed"
    else
        print_warning "Agent logo not found (your_agent_logo.gif)"
    fi

    if [ -f "your_admin_logo.gif" ]; then
        cp "your_admin_logo.gif" "${VICIDIAL_WEB_ROOT}/vicidial/vicidial_admin_web_logo.gif"
        chmod 644 "${VICIDIAL_WEB_ROOT}/vicidial/vicidial_admin_web_logo.gif"
        print_success "Admin logo deployed"
    else
        print_warning "Admin logo not found (your_admin_logo.gif)"
    fi

    # Deploy custom CSS
    print_warning "Step 2: Deploying custom CSS..."
    if [ -f "sample_custom.css" ]; then
        cp "sample_custom.css" "${VICIDIAL_WEB_ROOT}/agc/css/custom.css"
        chmod 644 "${VICIDIAL_WEB_ROOT}/agc/css/custom.css"
        print_success "Custom CSS deployed"
    else
        print_warning "Custom CSS not found (sample_custom.css)"
    fi

    # Link custom CSS in vicidial.php
    if ! grep -q "custom.css" "${VICIDIAL_WEB_ROOT}/agc/vicidial.php"; then
        print_warning "Adding custom.css link to vicidial.php..."
        # Add before </head> tag
        sed -i.bak '/<\/head>/i \<link rel="stylesheet" type="text/css" href="css/custom.css">' \
            "${VICIDIAL_WEB_ROOT}/agc/vicidial.php"
        print_success "Custom CSS linked in agent interface"
    fi

    # Deploy options.php if exists
    print_warning "Step 3: Deploying configuration files..."
    if [ -f "options.php" ]; then
        cp "options.php" "${VICIDIAL_WEB_ROOT}/agc/options.php"
        chmod 644 "${VICIDIAL_WEB_ROOT}/agc/options.php"
        print_success "Agent options.php deployed"
    fi

    # Set proper permissions
    print_warning "Step 4: Setting file permissions..."
    chown -R apache:apache "${VICIDIAL_WEB_ROOT}/agc/css/"
    chown -R apache:apache "${VICIDIAL_WEB_ROOT}/agc/images/"
    print_success "Permissions set"

    # Clear caches
    print_warning "Step 5: Clearing caches..."
    if command -v apachectl &> /dev/null; then
        apachectl -k graceful
        print_success "Apache reloaded gracefully"
    else
        systemctl reload apache2 || systemctl reload httpd
        print_success "Web server reloaded"
    fi

    print_success "Deployment completed successfully!"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Clear your browser cache (Ctrl+Shift+R)"
    echo "2. Test agent login"
    echo "3. Test admin login"
    echo "4. Verify all pages display correctly"
    echo "5. Check for JavaScript errors (F12 console)"
}

################################################################################
# Rollback Function
################################################################################

do_rollback() {
    print_header "ROLLING BACK TO PREVIOUS VERSION"

    # Find latest backup
    if [ ! -d "${BACKUP_DIR}/latest" ]; then
        print_error "No backup found to rollback to!"
        echo "Available backups:"
        ls -lh "$BACKUP_DIR"
        exit 1
    fi

    ROLLBACK_FROM="${BACKUP_DIR}/latest"
    echo -e "${YELLOW}Will rollback from: $ROLLBACK_FROM${NC}"
    echo ""
    cat "${ROLLBACK_FROM}/BACKUP_MANIFEST.txt"
    echo ""

    read -p "Proceed with rollback? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        print_error "Rollback cancelled"
        exit 1
    fi

    # Stop services
    print_warning "Stopping services..."
    systemctl stop apache2 || systemctl stop httpd
    print_success "Web server stopped"

    # Restore web files
    print_warning "Restoring web files..."
    tar -xzf "${ROLLBACK_FROM}/www_files.tar.gz" -C /
    print_success "Web files restored"

    # Restore database
    print_warning "Restoring database..."
    if [ -z "$DB_PASS" ]; then
        mysql -u "$DB_USER" -p "$DB_NAME" < "${ROLLBACK_FROM}/database_backup.sql"
    else
        mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "${ROLLBACK_FROM}/database_backup.sql"
    fi
    print_success "Database restored"

    # Restore Asterisk configs
    if [ -f "${ROLLBACK_FROM}/asterisk_config.tar.gz" ]; then
        tar -xzf "${ROLLBACK_FROM}/asterisk_config.tar.gz" -C /
        print_success "Asterisk configs restored"
    fi

    # Start services
    print_warning "Starting services..."
    systemctl start asterisk
    systemctl start apache2 || systemctl start httpd
    print_success "Services started"

    print_success "Rollback completed successfully!"
}

################################################################################
# Main Script
################################################################################

print_header "VICIdial White Label Deployment Tool"

# Check if running as root
check_root

# Check paths
check_paths

# Parse command
case "$1" in
    backup)
        do_backup
        ;;
    deploy)
        do_deploy
        ;;
    rollback)
        do_rollback
        ;;
    *)
        echo "Usage: $0 {backup|deploy|rollback}"
        echo ""
        echo "Commands:"
        echo "  backup   - Create a full backup of VICIdial installation"
        echo "  deploy   - Deploy white label customizations"
        echo "  rollback - Restore from latest backup"
        echo ""
        echo "Example workflow:"
        echo "  1. sudo $0 backup"
        echo "  2. sudo $0 deploy"
        echo "  3. Test changes"
        echo "  4. If issues: sudo $0 rollback"
        exit 1
        ;;
esac

echo ""
print_success "Operation completed!"
echo ""
