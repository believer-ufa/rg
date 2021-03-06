<rg-code>

	<div class="editor"></div>

	<script>
		let editor

		const setupEditor = () => {
			editor.setTheme(`ace/theme/${this.RgCode.theme}`)
			editor.getSession().setMode(`ace/mode/${this.RgCode.mode}`)
			editor.getSession().setTabSize(this.RgCode.tabsize)
			editor.getSession().setUseSoftTabs(this.RgCode.softtabs)
			editor.getSession().setUseWrapMode(this.RgCode.wordwrap)
			editor.setReadOnly(this.RgCode.readonly)
			this.update()
		}

		this.on('mount', () => {
			editor = ace.edit(this.root.querySelector('.editor'))
			editor.$blockScrolling = Infinity

			this.RgCode = opts.editor || new RgCode()
			this.RgCode.on('settings', () => {
				setupEditor()
			})
			this.RgCode.on('change src', () => {
				if (this.RgCode.code != editor.getValue())
					editor.setValue(this.RgCode.code)
			})
			editor.setValue(this.RgCode.code)
			editor.getSession().on('change', e => {
				this.RgCode.code = editor.getValue()
				if (this.RgCode.onchange) {
					this.RgCode.onchange(editor.getValue())
				}
			})
			setupEditor()
		})

	</script>

	<style scoped>
		.editor {
			position: absolute;
			top: 0;
			right: 0;
			bottom: 0;
			left: 0;
		}

	</style>
</rg-code>
