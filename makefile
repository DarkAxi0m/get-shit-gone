APP_NAME = getshitdone
VERSION = 1.0.1
ARCH = amd64

BUILD_DIR = $(APP_NAME)_$(VERSION)
BIN_DIR = $(BUILD_DIR)/usr/local/bin
MAN_DIR = $(BUILD_DIR)/usr/share/man/man1
COMPLETE_DIR = $(BUILD_DIR)/etc/bash_completion.d
DEBIAN_DIR = $(BUILD_DIR)/DEBIAN
OUTPUT = $(APP_NAME)_$(VERSION).deb

SRC = main.go

all: build package

build:
	go build -o $(APP_NAME)

prepare:
	mkdir -p $(BIN_DIR) $(MAN_DIR) $(COMPLETE_DIR) $(DEBIAN_DIR)
	cp $(APP_NAME) $(BIN_DIR)/
	gzip -c getshitdone.1 > $(MAN_DIR)/getshitdone.1.gz
	cp getshitdone.bash $(COMPLETE_DIR)/getshitdone

control:
	echo "Package: $(APP_NAME)" > $(DEBIAN_DIR)/control
	echo "Version: $(VERSION)" >> $(DEBIAN_DIR)/control
	echo "Section: utils" >> $(DEBIAN_DIR)/control
	echo "Priority: optional" >> $(DEBIAN_DIR)/control
	echo "Architecture: $(ARCH)" >> $(DEBIAN_DIR)/control
	echo "Depends: bash" >> $(DEBIAN_DIR)/control
	echo "Maintainer: Christopher Chase" >> $(DEBIAN_DIR)/control
	echo "Description: Toggle /etc/hosts to block distractions (work/play/add/remove)." >> $(DEBIAN_DIR)/control

package: build prepare control
	dpkg-deb --build $(BUILD_DIR)
	@echo "Created $(OUTPUT)"

clean:
	rm -rf $(APP_NAME) $(BUILD_DIR) $(OUTPUT)

install: $(OUTPUT)
	sudo dpkg -i $(OUTPUT)

