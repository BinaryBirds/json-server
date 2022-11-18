release: 
	swift build -c release

update:
	swift package update

clean:
	rm -rf .build

test:
	swift test --parallel

deploy: release
	sudo systemctl stop jsonserver
	sudo cp .build/release/Run /var/www/jsonserver.binarybirds.com/
	sudo systemctl start jsonserver
	sudo systemctl status jsonserver
