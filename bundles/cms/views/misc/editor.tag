<editor>
  <div class={ 'editor' : true, 'd-none' : !this.eden.frontend }>
    <label if={ opts.label }>{ opts.label }</label>
    <div ref="editor">{ opts.content }</div>
    <input type="file" ref="upload" name="file" onchange={ onFile } class="d-none" />
  </div>

  <script>
    // do mixins
    this.mixin('media');

    // set variables
    this.value = opts.content;
    this.editor = false;

    /**
     * set next
     *
     * @param {Object} next
     */
    shouldUpdate (next) {
      // check next
      if (!this.editor) return true;

      // return false
      return false;
    }

    /**
     * returns value
     *
     * @return {String}
     */
    val () {
      // return value
      return this.content;
    }

    /**
     * initialises summernote
     *
     * @private
     */
    init () {
      // require quill
      const Quill = require('quill');

      // create editor
      this.editor = new Quill(this.refs.editor, {
        'theme' : 'snow'
      });

      // set content
      this.editor.on('text-change', (delta) => {
        // set content
        this.content = this.refs.editor.firstChild.innerHTML;

        // on update
        if (opts.onUpdate) {
          // set content
          opts.onUpdate(this.content);
        }
      });
    }

    /**
     * on mount function
     *
     * @param {Event} 'mount'
     */
    this.on('mount', () => {
      // check if frontend
      if (!this.eden.frontend) return;

      // set inner html
      this.refs.editor.innerHTML = opts.content || '';

      // init summernote
      this.init();
    });

    /**
     * on unmount function
     *
     * @param {Event} 'unmount'
     */
    this.on('unmount', () => {
      // check if frontend
      if (!this.eden.frontend) return;

    });
  </script>
</editor>
