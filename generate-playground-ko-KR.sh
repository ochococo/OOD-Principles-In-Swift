#!/bin/bash

# Note: I think this part is absolute garbage but it's a snapshot of my current skills with Bash. 
# Would love to rewrite it in Swift soon.

combineSwift() {
	cat source-ko-KR/startComment >> $2
	cat source-ko-KR/header.md >> $2
	cat source-ko-KR/endComment >> $2
	cat source-ko-KR/imports.swift >> $2
	cat $1/srp.swift >> $2
	cat $1/ocp.swift >> $2
	cat $1/lsp.swift >> $2
	cat $1/isp.swift >> $2
	cat $1/dip.swift >> $2
	cat source-ko-KR/startComment >> $2
	cat source-ko-KR/footer.md  >> $2
	cat source-ko-KR/endComment >> $2
	{ rm $2 && awk '{gsub("\\*//\\*:", "", $0); print}' > $2; } < $2
}

move() {
	mv $1.swift OOD-Principles-In-Swift-ko-KR.playground/contents.swift
}

playground() {
	combineSwift source-ko-KR/$1 $1.swift 
	move $1
}

combineMarkdown() {
	cat source-ko-KR/header.md >> $2
	cat source-ko-KR/startSwiftCode >> $2
	cat $1/srp.swift >> $2
	cat $1/ocp.swift >> $2
	cat $1/lsp.swift >> $2
	cat $1/isp.swift >> $2
	cat $1/dip.swift >> $2

	{ rm $2 && awk '{gsub("\\*//\\*:", "", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("\\*/", "\n```swift", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("/\\*:", "```\n", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("```swift```", "", $0); print}' > $2; } < $2
	
	cat source-ko-KR/endSwiftCode >> $2
}

readme() {
	echo "" > $2
	combineMarkdown source-ko-KR/$1 $2
	cat source-ko-KR/footer.md  >> $2
}

playground SOLID

zip -r -X OOD-Principles-In-Swift-ko-KR.playground.zip ./OOD-Principles-In-Swift-ko-KR.playground

readme SOLID README-ko-KR.md