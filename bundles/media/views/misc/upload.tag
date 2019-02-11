<upload>
  <div class="row row-eq-height upload upload-images">
    <div each={ file, i in this.value } class="{ opts.col || 'col-6 col-md-4 col-xl-3' } form-group-image mb-2">
      <div class="card card-outline-primary" style="background-image: url({ thumb(file) })">
        <span class="btn-group p-0" if={ this.multi }>
          <button onclick={ onPrev } class="btn btn-primary">
            <i class="fa fa-chevron-left" />
          </button>
          <button onclick={ onNext } class="btn btn-primary">
            <i class="fa fa-chevron-right" />
          </button>
        </span>
        <a href="#!" onclick={ onRemove } class="btn btn-danger">
          <i class="fa fa-times" />
        </a>
        <input type="hidden" if={ file.id } name={ this.name + (this.multi ? '[' + i + ']' : '') } value={ file.id } class="file-input">
        <div class="progress" if={ typeof file.uploaded !== 'undefined' }>
          <div class="progress-bar bg-success" role="progressbar" style="width : { file.uploaded }%;" aria-valuenow={ file.uploaded } aria-valuemin="0" aria-valuemax="100"></div>
        </div>
      </div>
    </div>
    <div class="col-6 col-md-4 col-xl-3 mb-2" if={ this.multi || !this.value.length }>
      <label class="card card-outline-success card-upload" for={ this.name }>
        <input type="file" ref="file" id={ this.name } name={ this.name } class="file-input" multiple={ this.multi } onchange={ onUpload }>
        <div class="d-flex align-items-center">
          <div>
            <i class="fa fa-plus" />
            <div class="upload-label" class="mt-2">
              Upload Image
            </div>
          </div>
        </div>
      </label>
    </div>
  </div>

  <script>
    // add mixins
    this.mixin('media');

    // set value
    this.name    = opts.name || 'image';
    this.multi   = opts.multi;
    this.value   = opts.image ? (Array.isArray(opts.image) ? opts.image : [opts.image]) : [];
    this.change  = false;
    this.loading = [];
    this.removed = [];

    /**
     * src of file
     *
     * @param {Object} file
     */
    src (file) {
      // return thumb if exists
      if (!file.id) return file.src;

      // return file
      return this.media.url(file);
    }

    /**
     * thumb of file
     *
     * @param {Object} file
     */
    thumb (file) {
      // return thumb if exists
      if (file.thumb) return file.thumb;

      // return file
      return this.media.url(file, '3x-sq');
    }

    /**
     * on next
     *
     * @param  {Event} e
     */
    onNext (e) {
      // prevent default
      e.preventDefault();

      // check i
      let i = e.item.i;

      // splice to new position
      this.value.splice((i + 1), 0, this.value.splice(i, 1)[0]);

      // update
      this.update();
    }

    /**
     * on next
     *
     * @param  {Event} e
     */
    onPrev (e) {
      // prevent default
      e.preventDefault();

      // check i
      let i = e.item.i;

      // splice to new position
      this.value.splice((i - 1), 0, this.value.splice(i, 1)[0]);

      // update
      this.update();
    }

    /**
     * on remove function
     *
     * @param {Event} e
     */
    onRemove (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // loop values
      this.removed.push(e.item.file.id || e.item.file.temp);

      // set value
      this.value.splice(e.item.i, 1);

      // update view
      this.update();
    }

    /**
     * upload function
     *
     * @param {Event} e
     *
     * @private
     */
    onUpload (e) {
      // check files
      if (e.target.files.length === 0) {
        // alert
        return eden.alert.alert('error', 'Please set files');
      }
      
      // require uuid
      const uuid = require('uuid');

      // loop files
      for (var i = 0; i < e.target.files.length; i++) {
        // set file
        let fl = e.target.files[i];

        // create new reader
        let fr = new FileReader();

        // onload
        fr.onload = () => {
          // let value
          let value = {
            'src'      : fr.result,
            'file'     : fl,
            'name'     : fl.name,
            'size'     : fl.size,
            'temp'     : uuid(),
            'thumb'    : fr.result,
            'uploaded' : 0
          };

          // add to value
          this.value.push(value);

          // do upload
          this._ajaxUpload(value);

          // update view
          this.update();
        };

        // read file
        fr.readAsDataURL(fl);
      }
    }

    /**
     * updates value
     *
     * @param {Value} val
     */
    _update (val) {
      // let id
      let id = val.id;

      // check uuid
      if (val.temp) id = val.temp;

      // loop values
      for (var i = 0; i < this.value.length; i++) {
        // check value
        if (this.value[i].id === id || this.value[i].temp === id) {
          // set value
          this.value[i] = val;

          // return update
          return this.update();
        }
      }
    }

    /**
     * remove value from upload
     *
     * @param {Object} val
     *
     * @private
     */
    _remove (val) {
      // let id
      let id = val.id;

      // check uuid
      if (val.temp) id = val.temp;

      // loop values
      for (var i = 0; i < this.value.length; i++) {
        // check value
        if (this.value[i].id === id || this.value[i].temp === id) {
          // set value
          this.value.splice(i, 1);

          // return update
          return this.update();
        }
      }
    }

    /**
     * ajax upload function
     *
     * @param {Object} value
     *
     * @private
     */
    _ajaxUpload (value) {
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

      // submit ajax form
      this.loading.push(new Promise((resolve, reject) => {
        jQuery.ajax({
          'url' : '/media/image',
          'xhr' : () => {
            // get the native XmlHttpRequest object
            var xhr = jQuery.ajaxSettings.xhr();
  
            // set the onprogress event handler
            xhr.upload.onprogress = (evt) => {
              // log progress
              let progress = (evt.loaded / evt.total) * 100;
  
              // set progress
              value.uploaded = progress;
  
              // update
              this._update(value);
            };
  
            // return the customized object
            return xhr;
          },
          'data'  : data,
          'type'  : 'post',
          'cache' : false,
          'error' : () => {
            // do error
            eden.alert.alert('error', 'Error uploading image');
  
            // remove from array
            this._remove(value);
          },
          'success' : (data) => {
            // empty file upload
            if (change === this.change) {
              // reset file
              if (this.refs.file) this.refs.file.value = null;
            }
  
            // check if error
            if (data.error) {
              // error
              reject(data.message);
              
              // do message
              return eden.alert.alert('error', data.message);
            }
  
            // check if image
            if (data.upload) this._update(data.upload);
            
            // resolve
            resolve(data.upload);
          },
          'dataType'    : 'json',
          'contentType' : false,
          'processData' : false
        });
      }));
    }

    /**
     * on mount function
     *
     * @param {Event} 'mount'
     */
    this.on('update', () => {
      // check if frontend
      if (!this.eden.frontend) return true;

      // check new
      let images = opts.image ? (Array.isArray(opts.image) ? opts.image : [opts.image]) : [];

      // set value
      this.value.push(...images.filter((image) => {
        // find
        return (!this.value.find((img) => img.id === image.id)) && this.removed.indexOf(image.id) === -1;
      }));
    });
  </script>
</upload>
