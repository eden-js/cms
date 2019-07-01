<editor>
  <div class={ 'editor' : true, 'd-none' : !this.eden.frontend }>
    <label if={ opts.label }>{ opts.label }</label>
    <textarea name={ opts.name } ref="editor">{ opts.content }</textarea>
    <input type="file" ref="upload" name="file" onchange={ onFile } class="d-none" />
  </div>

  <script>
    // do mixins
    this.mixin('media');

    // set variables
    this.value = opts.content;
    this.summernote = false;

    /**
     * on image upload
     *
     * @param {File} image
     */
    _image (image) {
      // loop image
      if (!image || !image.length) return;

      // loop image
      for (var i = 0; i < image.length; i++) {
        // let file
        let fl = image[i];

        // create new reader
        let fr = new FileReader();

        // onload
        fr.onload = () => {
          // require uuid
          const uuid = require('uuid');

          // let uuid
          let id   = uuid();
          let type = 'image';

          // let value
          let value = {
            'id'        : id,
            'src'       : fr.result,
            'file'      : fl,
            'name'      : fl.name,
            'size'      : fl.size,
            'temp'      : id,
            'thumb'     : fr.result,
            'uploaded'  : 0,
            'selection' : this.selection,
          };

          // set files
          let files = ['pdf', 'docx', 'txt'];

          // check type
          if (value.name.includes('.pdf')) {
            // set type
            type = 'file';

            // insert html
            let fileHTML = jQuery('<a target="_BLANK" href="#uploading" data-id="' + value.temp + '">' + value.name + '</a>');

            // insert image
            let insert = jQuery(this.refs.editor).summernote('insertNode', fileHTML[0]);
          } else {
            // create figure
            let imageHTML   = jQuery('<img src="' + value.src + '" data-id="' + value.temp + '" class="img-resize img-fluid img-grayscale" />');
            let figureHTML  = jQuery('<figure class="embed figure-image" style="display:table" />');
            let captionHTML = jQuery('<figcaption class="img-caption" />');

            // append/prepend elements
            imageHTML.prependTo(figureHTML);
            captionHTML.appendTo(figureHTML);

            // insert image
            let insert = jQuery(this.refs.editor).summernote('insertNode', figureHTML[0]);
          }

          // do upload
          this._ajaxUpload(value, type);
        };

        // read file
        fr.readAsDataURL(fl);
      }
    }

    /**
     * ajax upload function
     *
     * @param {Object} value
     *
     * @private
     */
    _ajaxUpload (value, type) {
      // require uuid
      const uuid = require('uuid');

      // let change
      this.change = uuid();

      // set change
      let change = this.change;

      // create form data
    	let data = new FormData();

      // append image
    	data.append('file', value.file);
      data.append('temp', value.temp);

      // kill timeout
      if (this.timeout) clearTimeout(this.timeout);

      // submit ajax form
    	jQuery.ajax ({
        'url'   : '/media/' + (type || 'image'),
        'data'  : data,
        'type'  : 'post',
        'cache' : false,
        'error' : () => {
          // do error
          eden.alert.alert('error', 'Error uploading image');

          // remove from array
          this._remove (value);
        },
        'success' : (data) => {
          // clear ref
          this.refs.upload.value = '';

          // remove overlay
          jQuery('.note-link-popover').hide();

          // load image
          let place = jQuery('[data-id="' + value.temp + '"]', this.root);

          // check if error
          if (data.error) {
            // do message
            return eden.alert.alert('error', data.message);

            // remove image
            if (place) place.remove();
          }

          // check if image
          if (data.upload) {
            // check image
            if (place) {
              // set img
              place.attr (type === 'file' ? 'href' : 'src', this.media.url(data.upload));

              // remove gray
              place.removeClass('img-grayscale');

              // remove i
              let i = jQuery('i', place);

              // check i
              if (i && i.length) i.remove();
            }

            // do update
            this.trigger('change');
          }
        },
        'dataType'    : 'json',
        'contentType' : false,
        'processData' : false
      });
    }

    /**
     * on file upload
     *
     * @param {Event} e
     */
    onFile (e) {
      // check files
      if (!e.target.files.length) return;

      // require uuid
      const uuid = require('uuid');

      // let uuid
      let id = uuid();

      // let value
      let value = {
        'id'       : id,
        'file'     : e.target.files[0],
        'name'     : e.target.files[0].name,
        'size'     : e.target.files[0].size,
        'temp'     : id,
        'uploaded' : 0
      };

      // insert image
      let insert = jQuery(this.refs.editor).summernote('insertNode', jQuery('<a href="#uploading" target="_blank" data-id="' + id + '">' + e.target.files[0].name + ' <i>Uploading...</i></a>')[0]);

      // do upload
      this._ajaxUpload(value, 'file');
    }

    /**
     * set next
     *
     * @param {Object} next
     */
    shouldUpdate (next) {
      // check next
      if (!this.summernote) return true;

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
      return jQuery(this.refs.editor).summernote('code');
    }

    /**
     * initialises summernote
     *
     * @private
     */
    _summernote () {
      // set icon replacements
      let icons = {
        'align'         : 'fa fa-align',
        'alignCenter'   : 'fa fa-align-center',
        'alignJustify'  : 'fa fa-align-justify',
        'alignLeft'     : 'fa fa-align-left',
        'alignRight'    : 'fa fa-align-right',
        'indent'        : 'fa fa-indent',
        'outdent'       : 'fa fa-outdent',
        'arrowsAlt'     : 'fa fa-arrows-alt',
        'bold'          : 'fa fa-bold',
        'caret'         : 'fa fa-caret',
        'circle'        : 'fa fa-circle',
        'close'         : 'fa fa-close',
        'code'          : 'fa fa-code',
        'eraser'        : 'fa fa-eraser',
        'font'          : 'fa fa-font',
        'frame'         : 'fa fa-frame',
        'italic'        : 'fa fa-italic',
        'link'          : 'fa fa-link',
        'unlink'        : 'fa fa-chain-broken',
        'magic'         : 'fa fa-magic',
        'menuCheck'     : 'fa fa-check',
        'minus'         : 'fa fa-minus',
        'orderedlist'   : 'fa fa-list-ol',
        'pencil'        : 'fa fa-pencil-alt',
        'picture'       : 'fa fa-image',
        'question'      : 'fa fa-question',
        'redo'          : 'fa fa-redo',
        'square'        : 'fa fa-square',
        'strikethrough' : 'fa fa-strikethrough',
        'subscript'     : 'fa fa-subscript',
        'superscript'   : 'fa fa-superscript',
        'table'         : 'fa fa-table',
        'textHeight'    : 'fa fa-text-height',
        'trash'         : 'fa fa-trash',
        'underline'     : 'fa fa-underline',
        'undo'          : 'fa fa-undo',
        'unorderedlist' : 'fa fa-list-ul',
        'video'         : 'fa fa-film'
      };

      // set toolbar
      let toolbar = [
        ['style', ['style']],
        ['style', ['bold', 'italic', 'underline', 'strikethrough', 'superscript', 'subscript', 'clear']],
        ['fontname', ['fontname']],
        ['fontsize', ['fontsize']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['height', ['height']],
        ['table', ['table']],
        ['insert', ['link', 'picture', 'videoAttributes', 'caption', 'hr', 'file']],
        ['view', ['fullscreen', 'codeview']],
        ['help', ['help']]
      ];

      // run summernote
      this.summernote = jQuery(this.refs.editor).summernote({
        'focus'     : false,
        'icons'     : icons,
        'toolbar'   : toolbar,
        'airMode'   : !!opts.airMode,
        'onChange'  : () => {
          // trigger change
          this.trigger('change');
        },
        'callbacks' : {
          'onBlur' : () => {
            // trigger change
            this.trigger('change');
          },
          'onImageUpload' : this._image
        },
        'popover' : !!opts.airMode ? undefined : {
          'image' : [
            ['remove', ['removeMedia']]
          ],
        }
      });

      // trigger change on keyup
      jQuery('.note-codable', this.root).on('keyup', () => {
        // trigger change on keyup
        this.trigger('change');
      });

      // remove toolbar
      jQuery('body > .note-popover').hide();
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
      this.refs.editor.innerHTML = opts.content;

      // init summernote
      this._summernote();
    });

    /**
     * on change function
     *
     * @param {Event} 'change'
     */
    this.on('change', () => {
      // check if frontend
      if (!this.eden.frontend) return;

      // set value
      this.value = jQuery('.note-codable', this.root).is(':visible') ? jQuery('.note-codable', this.root).val() : jQuery(this.refs.editor).summernote('code');

      // on update
      if (opts.onUpdate) {
        // set content
        opts.onUpdate(this.value);
      }

      // set value
      jQuery(this.refs.editor).val(jQuery(this.refs.editor).summernote('code'));
    });

    /**
     * on unmount function
     *
     * @param {Event} 'unmount'
     */
    this.on('unmount', () => {
      // check if frontend
      if (!this.eden.frontend) return;

      // destroy summernote
      jQuery(this.refs.editor).summernote('destroy');
    });
  </script>
</editor>
