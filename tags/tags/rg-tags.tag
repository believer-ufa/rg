<rg-tags>

	<div class="container">
		<span class="tags">
			<span class="tag" each="{ opts.tags }" onclick="{ parent.removeTag }">
				{ text }
				<span class="close">&times;</span>
			</span>
		</span>

		<div class="field-container { visible: visible }">
			<input type="{ opts.type || 'text' }"
						 class="field"
						 name="filterField"
						 placeholder="{ opts.placeholder }"
						 onkeydown="{ handleKeys }"
						 oninput="{ filterItems }"
						 onfocus="{ filterItems }">

			<div class="dropdown { visible: visible }">
				<ul class="list">
					<li each="{ filteredItems }"
							onclick="{ parent.select }"
							class="item { active: active }">
						{ text }
					</li>
				</ul>
			</div>
		</div>
	</div>

	<script>
		this.visible = false
		this.filterField.value = opts.value || ''
		opts.options = opts.options || []
		opts.tags = opts.tags || []
		opts.tags.forEach((tag, i) => tag.index = i)

		this.filterItems = () => {
			this.filteredItems = opts.options.filter(item => {
				item.active = false
				if (this.filterField.value.length == 0 ||
					item.text.toString()
					         .toLowerCase()
									 .indexOf(this.filterField.value.toString().toLowerCase()) > -1)
					return true
			})
			this.visible = this.filteredItems.length > 0
			if (rg.isFunction(opts.onfilter)) opts.onfilter()
			this.update()
		}

		this.handleKeys = e => {
			let length = this.filteredItems.length
			if (length > 0 && [13, 38, 40].indexOf(e.keyCode) > -1) {
				this.visible = true
				e.preventDefault()
				// Get the currently selected item
				let activeIndex = null
				for (var i = 0; i < length; i++) {
					let item = this.filteredItems[i]
					if (item.active) {
						activeIndex = i
						break
					}
				}

				// We're leaving this item
				if (activeIndex != null) this.filteredItems[activeIndex].active = false

				if (e.keyCode == 38) {
					// Move the active state to the next item lower down the index
					if (activeIndex == null || activeIndex == 0)
						this.filteredItems[length - 1].active = true
					else
						this.filteredItems[activeIndex - 1].active = true
				} else if (e.keyCode == 40) {
					// Move the active state to the next item higher up the index
					if (activeIndex == null || activeIndex == length - 1)
						this.filteredItems[0].active = true
					else
						this.filteredItems[activeIndex + 1].active = true
				} else if (e.keyCode == 13 && activeIndex != null) {
					this.select({ item: this.filteredItems[activeIndex] })
				}
			}
			if (e.keyCode == 13) {
				this.addTag()
			} else if (e.keyCode == 8 && this.filterField.value == '' && opts.tags.length > 0) {
				let tag = opts.tags.pop()
				this.filterField.value = tag.text
			}
			return true
		}

		this.addTag = item => {
			let tag = item || { text: this.filterField.value }
			if (tag.text.length > 0) {
				tag.index = opts.tags.length
				opts.tags.push(tag)
				this.filterField.value = ''
				this.filteredItems = opts.options
				this.visible = false
			}
			this.update()
		}

		this.removeTag = e => {
			opts.tags.splice(opts.tags.indexOf(e.item), 1)
			this.visible = false
		}

		this.select = item => {
			item = item.item
			if (rg.isFunction(opts.onselect)) opts.onselect(item)
			this.addTag(item)
		}

		this.closeDropdown = e => {
			if (!this.root.contains(e.target)) {
				if (rg.isFunction(opts.onclose) && this.visible) opts.onclose()
				this.visible = false
				this.update()
			}
		}

		this.on('mount', () => {
			document.addEventListener('click', this.closeDropdown)
			document.addEventListener('focus', this.closeDropdown, true)
			this.visible = opts.visible
			this.update()
		})

		this.on('unmount', () => {
			document.removeEventListener('click', this.closeDropdown)
			document.removeEventListener('focus', this.closeDropdown, true)
		})

		this.on('update', () => {
			if (this.isMounted) {
				const container = this.root.querySelector('.container')
				let containerWidth = container.getBoundingClientRect().width
				let tagList = this.root.querySelector('.tags')
				let tagListWidth = tagList.getBoundingClientRect().width
				tagList.scrollLeft = Number.MAX_VALUE

				let fieldContainer = this.root.querySelector('.field-container')
				fieldContainer.style.width = `${(containerWidth - tagListWidth)}px`
				this.root.querySelector('.container').style.height = `${fieldContainer.getBoundingClientRect().height}px`
			}
		})
	</script>

	<style scoped>
		.container {
			position: relative;
			width: 100%;
			border: 1px solid #D3D3D3;
			background-color: white;
			text-align: left;
			padding: 0;
			box-sizing: border-box;
		}

		.field-container {
			position: absolute;
			display: inline-block;
			cursor: pointer;
		}

		.field {
			width: 100%;
			padding: 10px;
			border: 0;
			box-sizing: border-box;
			background-color: transparent;
			white-space: nowrap;
			font-size: 1em;
			line-height: normal;
			outline: 0;
		}

		.dropdown {
			display: none;
			position: absolute;
			width: 100%;
			background-color: white;
			border-bottom: 1px solid #D3D3D3;
			box-sizing: border-box;
			overflow-y: auto;
			overflow-x: hidden;
			max-height: 280px;
			margin: -1px 0 0 -1px;
		}

		.dropdown.visible {
			display: block;
		}

		.list, .item {
			list-style: none;
			padding: 0;
			margin: 0;
		}

		.list.empty {
			display: none;
		}

		.item {
			padding: 10px;
			border-left: 1px solid #D3D3D3;
			border-right: 1px solid #D3D3D3;
			border-top: 1px solid #E8E8E8;
			white-space: nowrap;
			overflow: hidden;
			text-overflow: ellipsis;
		}

		.item:first-child {
			border-top: 0;
		}

		.item:hover {
			background-color: #f3f3f3;
		}

		.item.active,
		.item:hover.active {
			background-color: #ededed;
		}

		.tags {
			display: inline-block;
			max-width: 70%;
			white-space: nowrap;
			overflow-y: hidden;
			overflow-x: auto;
			-webkit-user-select: none;
			-moz-user-select: none;
			-ms-user-select: none;
			user-select: none;
		}

		.tag {
			position: relative;
			display: inline-block;
			padding: 8px 20px 8px 5px;
			margin: 1px;
			background-color: #000;
			color: #fff;
			font-size: 1em;
			line-height: normal;
			cursor: pointer;
		}

		.tag:hover, .tag:active {
			background-color: #666;
		}

		.close {
			position: absolute;
			right: 5px;
			top: 7px;
			color: rgba(255, 255, 255, 0.7);
		}

	</style>
</rg-tags>
