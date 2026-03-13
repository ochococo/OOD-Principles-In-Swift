#!/bin/bash

# Note: I think this part is absolute garbage but it's a snapshot of my current skills with Bash.
# Would love to rewrite it in Swift soon.

combineSwift() {
	cat source-es/startComment >> $2
	cat source-es/header.md >> $2
	cat source-es/endComment >> $2
	cat source-es/imports.swift >> $2
	cat $1/srp.swift >> $2
	cat $1/ocp.swift >> $2
	cat $1/lsp.swift >> $2
	cat $1/isp.swift >> $2
	cat $1/dip.swift >> $2
	cat source-es/startComment >> $2
	cat source-es/footer.md  >> $2
	cat source-es/endComment >> $2
	{ rm $2 && awk '{gsub("\\*//\\*:", "", $0); print}' > $2; } < $2
}

move() {
	mv $1.swift OOD-Principles-In-Swift-es.playground/contents.swift
}

playground() {
	combineSwift source-es/$1 $1.swift
	move $1
}

combineMarkdown() {
	cat source-es/header.md >> $2
	cat source-es/startSwiftCode >> $2
	cat $1/srp.swift >> $2
	cat $1/ocp.swift >> $2
	cat $1/lsp.swift >> $2
	cat $1/isp.swift >> $2
	cat $1/dip.swift >> $2

	{ rm $2 && awk '{gsub("\\*//\\*:", "", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("\\*/", "\n```swift", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("/\\*:", "```\n", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("```swift```", "", $0); print}' > $2; } < $2

	cat source-es/endSwiftCode >> $2
}

readme() {
	echo "" > $2
	combineMarkdown source-es/$1 $2
	cat source-es/footer.md  >> $2
}

playground SOLID

zip -r -X OOD-Principles-In-Swift-es.playground.zip ./OOD-Principles-In-Swift-es.playground

readme SOLID README-es.md
