#!/bin/bash

# Note: I think this part is absolute garbage but it's a snapshot of my current skills with Bash.
# Would love to rewrite it in Swift soon.

combineSwift() {
	cat source-fr/startComment >> $2
	cat source-fr/header.md >> $2
	cat source-fr/endComment >> $2
	cat source-fr/imports.swift >> $2
	cat $1/srp.swift >> $2
	cat $1/ocp.swift >> $2
	cat $1/lsp.swift >> $2
	cat $1/isp.swift >> $2
	cat $1/dip.swift >> $2
	cat source-fr/startComment >> $2
	cat source-fr/footer.md  >> $2
	cat source-fr/endComment >> $2
	{ rm $2 && awk '{gsub("\\*//\\*:", "", $0); print}' > $2; } < $2
}

move() {
	mv $1.swift OOD-Principles-In-Swift-fr.playground/contents.swift
}

playground() {
	combineSwift source-fr/$1 $1.swift
	move $1
}

combineMarkdown() {
	cat source-fr/header.md >> $2
	cat source-fr/startSwiftCode >> $2
	cat $1/srp.swift >> $2
	cat $1/ocp.swift >> $2
	cat $1/lsp.swift >> $2
	cat $1/isp.swift >> $2
	cat $1/dip.swift >> $2

	{ rm $2 && awk '{gsub("\\*//\\*:", "", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("\\*/", "\n```swift", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("/\\*:", "```\n", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("```swift```", "", $0); print}' > $2; } < $2

	cat source-fr/endSwiftCode >> $2
}

readme() {
	echo "" > $2
	combineMarkdown source-fr/$1 $2
	cat source-fr/footer.md  >> $2
}

playground SOLID

zip -r -X OOD-Principles-In-Swift-fr.playground.zip ./OOD-Principles-In-Swift-fr.playground

readme SOLID README-fr.md
