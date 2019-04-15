#!/bin/bash

# Note: I think this part is absolute garbage but it's a snapshot of my current skills with Bash. 
# Would love to rewrite it in Swift soon.

combineSwift() {
	cat source/startComment > $2
	cat $1/header.md  >> $2
	cat source/contents.md  >> $2
	cat source/endComment >> $2
	cat source/imports.swift >> $2
	cat $1/*.swift >> $2
	{ rm $2 && awk '{gsub("\\*//\\*:", "", $0); print}' > $2; } < $2
}

move() {
	mv $1.swift OOD-Principles-In-Swift.playground/contents.swift
}

playground() {
	combineSwift source/$1 $1.swift 
	move $1
}

combineMarkdown() {
	cat $1/header.md  > $2

	{ rm $2 && awk '{gsub("\\*/", "", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("/\\*:", "", $0); print}' > $2; } < $2

	cat source/startSwiftCode >> $2
	cat $1/*.swift >> $2

	{ rm $2 && awk '{gsub("\\*//\\*:", "", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("\\*/", "\n```swift", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("/\\*:", "```\n", $0); print}' > $2; } < $2
	
	cat source/endSwiftCode >> $2

	{ rm $2 && awk '{gsub("```swift```", "", $0); print}' > $2; } < $2

	cat $2 >> README.md
	rm $2
}

readme() {
	echo "" > $2
	combineMarkdown source/$1 $1.md
	cat source/footer.md  >> $2
}

playground SOLID

zip -r -X OOD-Principles-In-Swift.playground.zip ./OOD-Principles-In-Swift.playground

readme SOLID README.md