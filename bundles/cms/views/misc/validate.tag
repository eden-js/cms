<validate>
  <div class="{ opts.groupClass || 'form-group' }">
    <label for={ opts.name } class="text-bold">
      { opts.label }
    </label>
    <input if={ ['tel', 'text', 'email', 'number', 'password'].includes(opts.type) } id={ opts.name } name={ opts.name } onchange={ onChange } type={ opts.type } class="{ opts.inputClass || 'form-control' } { 'is-invalid' : isValid() === false, 'is-valid' : isValid() === true }" required={ opts.required } placeholder={ opts.label } value={ opts.value } />
    
    <div if={ isValid() === false } class="invalid-{ opts.errorType || 'tooltip' }">
      { this.message }
    </div>
    
    <yield />
  </div>
  
  <script>
    // set value
    this.value     = opts.value;
    this.message   = '';
    this.validated = false;
    
    /**
     * value
     *
     * @return {*}
     */
    val () {
      // return value
      return this.value;
    }
    
    /**
     * returns if valid
     *
     * @return {*}
     */
    isValid () {
      // check validated
      if (!this.validated) return null;
      
      // check length
      if (opts.minLength && (this.value || '').length < parseInt(opts.minLength)) {
        // set message
        this.message = 'Please make sure you use at least ' + opts.minLength + ' characters';

        // return false
        return false;
      }
      
      // check length
      if (opts.maxLength && (this.value || '').length < parseInt(opts.maxLength)) {
        // set message
        this.message = 'Please make sure you use at least ' + opts.maxLength + ' characters';

        // return false
        return false;
      }
      
      // check regex
      if (opts.regex && !opts.regex.test((this.value || '').toLowerCase())) {
        // set message
        this.message = 'Please make sure you enter valid information';

        // return false
        return false;
      }
      
      // check valid
      if (opts.isValid) {
        // check valid
        let valid = opts.isValid(this.value, this);
        
        // return error
        if (valid !== true) {
          // set message
          this.message = valid;
  
          // return false
          return false;
        }
      }
      
      // return valid
      return true;
    }
    
    /**
     * on change
     *
     * @param  {Event} e
     *
     * @return {*}
     */
    onChange (e) {
      // set value
      this.value = e.target.value;
    
      // set validated
      this.validated = true;
      
      // proxy change function
      if (opts.onChange) opts.onChange(e);
      
      // trigger update
      this.trigger('update');
    }
    
    /**
     * on submit
     *
     * @param  {Event} e
     *
     * @return {*}
     */
    onSubmit (e) {
      // set validated
      this.validated = true;
      
      // update view
      this.update();
      
      // return is mounted
      if (!this.isMounted) return;
      
      // check is valid
      if (this.isValid() === false) {
        e.preventDefault();
        e.stopPropagation();
        
        // return false
        return false;
      }
      
      // return true
      return true;
    }
    
    /**
     * on mount
     */
    this.on('mount', () => {
      // check parent
      if (!this.eden.frontend) return;
      
      // on form submit
      if (jQuery(this.root).closest('form').length) {
        // on submit
        jQuery(this.root).closest('form').on('submit', this.onSubmit);
      }
    });
    
    /**
     * on unmount
     */
    this.on('unmount', () => {
      // check parent
      if (!this.eden.frontend) return;
      
      // on form submit
      if (jQuery(this.root).closest('form').length) {
        // on submit
        jQuery(this.root).closest('form').off('submit', this.onSubmit);
      }
    });
    
  </script>
</validate>
