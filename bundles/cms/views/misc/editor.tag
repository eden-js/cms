<editor>
  <div class={ 'editor' : true, 'd-none' : !this.eden.frontend }>
    <label if={ opts.label }>{ opts.label }</label>
    <div ref="editor">{ opts.content }</div>
    <input if={ opts.name } class="hidden" type="hidden" name={ opts.name } value={ this.content } ref="value" />
  </div>

  <script>
    // do mixins
    this.mixin('media');

    // set variables
    this.editor  = false;
    this.content = opts.content;

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

      // set quill to window
      window.Quill = Quill;

      // require image upload
      require('quill-image-drop-module/image-drop.min.js');
      require('quill-image-resize-module/image-resize.min.js');
      require('quill-image-uploader/dist/quill.imageUploader.min.js');

      // create editor
      this.editor = new Quill(this.refs.editor, {
        'theme'   : 'snow',
        'modules' : {
          'toolbar' : {
            'container' : [
              ['bold', 'italic', 'underline', 'strike'],        // toggled buttons
              ['blockquote', 'code-block'],
              [{ 'align': [] }],

              [{ 'list': 'ordered'}, { 'list': 'bullet' }],
              [{ 'script': 'sub'}, { 'script': 'super' }],      // superscript/subscript

              [{ 'font': [] }],
              [{ 'size': ['small', false, 'large', 'huge'] }],  // custom dropdown

              [{ 'color': [] }, { 'background': [] }],          // dropdown with defaults from theme

              ['image'],
            	['html'],

              ['clean']
            ]
          },
          'imageDrop'     : true,
          'imageResize'   : {},
          'imageUploader' : {
            'upload' : async (file) => {
              // form data
              const data = new FormData();
              const uuid = require('uuid');

              // append file
              data.append('file', file);
              data.append('temp', uuid());

              // fetch
              let res = await fetch('/media/image', {
                'body'   : data,
                'method' : 'POST'
              });

              // await json
              res = await res.json();

              // return src
              return this.media.url(res.upload);
            }
          }
        }
      });

      // set content
      this.editor.on('text-change', (delta) => {
        // set content
        this.content = this.refs.editor.firstChild.innerHTML;

        // set to value
        if (this.refs.value) {
          // set content
          this.refs.value.value = this.content;
        }

        // on update
        if (opts.onUpdate) {
          // set content
          opts.onUpdate(this.content);
        }
      });

      // add html button
      const htmlButton = document.querySelector('.ql-html');

      // on click
      htmlButton.addEventListener('click', () => {
        // get editor
      	let htmlEditor = document.querySelector('.ql-html-editor');

        // check html editor
        if (htmlEditor) {
          // replace inner html
        	this.editor.root.innerHTML = htmlEditor.value.replace(/\n/g, '');
          this.editor.container.removeChild(htmlEditor.parentNode);
        } else {
          // get tidy
          const pretty = require('pretty');

          // create textarea element
          htmlEditor = document.createElement('textarea');
          htmlEditor.className = 'ql-editor ql-html-editor';
          htmlEditor.innerHTML = pretty(this.editor.root.innerHTML).replace(/\n\n/g, '\n');

          // create wrapper
          let htmlWrapper = document.createElement('code');

          // append child
          htmlWrapper.appendChild(htmlEditor);
          this.editor.container.appendChild(htmlWrapper);
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
