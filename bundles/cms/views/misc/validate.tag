<validate>
  <div class="{ opts.groupClass || 'form-group' } form-group-{ opts.type } { 'is-invalid' : isValid() === false, 'is-valid' : isValid() === true }">
    <label if={ !['checkbox'].includes(opts.type) } for={ opts.name } class="{ opts.labelClass || '' }">
      { opts.label }
    </label>

    <div class="input-group" if={ ['tel', 'text', 'email', 'number', 'password'].includes(opts.type) }>
      <div if={ opts.prepend } data-is={ opts.prepend } class="input-group-prepend" />
      <yield from="prepend" />
      <input autocomplete={ opts.autocomplete } id={ opts.name } name={ opts.name } onchange={ onChange } onkeyup={ onKeyup } type={ opts.type } class="{ opts.inputClass || 'form-control' } { 'is-invalid' : isValid() === false, 'is-valid' : isValid() === true }" required={ opts.required } placeholder={ opts.label } value={ this.value } />
      <div if={ opts.append } data-is={ opts.append } class="input-group-append" />
      <yield from="append" />
    </div>
    
    <div class="input-group" if={ ['textarea'].includes(opts.type) }>
      <div if={ opts.prepend } data-is={ opts.prepend } class="input-group-prepend" />
      <yield from="prepend" />
      <textarea autocomplete={ opts.autocomplete } id={ opts.name } name={ opts.name } onchange={ onChange } onkeyup={ onKeyup } class="{ opts.inputClass || 'form-control' } { 'is-invalid' : isValid() === false, 'is-valid' : isValid() === true }" required={ opts.required } placeholder={ opts.label }>{ this.value }</textarea>
      <div if={ opts.append } data-is={ opts.append } class="input-group-append" />
      <yield from="append" />
    </div>

    <div if={ ['date'].includes(opts.type) } class="row">
      <input class="hidden" type="hidden" name={ opts.name } value={ this.value } ref="date" />
      <div class="col-md-4">
        <select ref="day" class="{ opts.inputClass || 'form-control' } { 'is-invalid' : isValid() === false, 'is-valid' : isValid() === true }" onchange={ onDate }>
          <option each={ day, i in this.days } value={ day } selected={ this.value ? new Date(this.value).getDate() === day : null }>{ day }</option>
        </select>
      </div>
      <div class="col-md-4">
        <select ref="month" class="{ opts.inputClass || 'form-control' } { 'is-invalid' : isValid() === false, 'is-valid' : isValid() === true }" onchange={ onDate }>
          <option each={ month, i in this.months } value={ month } selected={ this.value ? new Date(this.value).getMonth() === i : null }>{ month }</option>
        </select>
      </div>
      <div class="col-md-4">
        <select ref="year" class="{ opts.inputClass || 'form-control' } { 'is-invalid' : isValid() === false, 'is-valid' : isValid() === true }" onchange={ onDate }>
          <option each={ year, i in this.years } value={ year } selected={ this.value ? new Date(this.value).getFullYear() === year : null }>{ year }</option>
        </select>
      </div>
    </div>

    <div class="input-group" if={ ['boolean'].includes(opts.type) }>
      <div if={ opts.prepend } data-is={ opts.prepend } class="input-group-prepend" />
      <yield from="prepend" />
      <select autocomplete={ opts.autocomplete } id={ opts.name } name={ opts.name } onchange={ onChange } class="{ opts.inputClass || 'form-control' } { 'is-invalid' : isValid() === false, 'is-valid' : isValid() === true }" required={ opts.required } placeholder={ opts.label }>
        <option value="true" selected={ this.value }>Yes</option>
        <option value="true" selected={ !this.value }>No</option>
      </select>
      <div if={ opts.append } data-is={ opts.append } class="input-group-append" />
      <yield from="append" />
    </div>

    <div if={ ['checkbox'].includes(opts.type) } class="custom-control custom-checkbox { 'is-invalid' : isValid() === false, 'is-valid' : isValid() === true }">
      <input type="checkbox" class="{ opts.inputClass || 'custom-control-input' } { 'is-invalid' : isValid() === false, 'is-valid' : isValid() === true }" name={ opts.name } value={ opts.default || 'true' } id={ opts.name } checked={ opts.checked } onchange={ onChange } />
      <label class="custom-control-label" for={ opts.name }>{ opts.label }</label>

      <div if={ isValid() === false } class="invalid-{ opts.errorType || 'tooltip' }">
        { this.message }
      </div>
    </div>

    <div if={ !['checkbox'].includes(opts.type) && isValid() === false } class="invalid-{ opts.errorType || 'tooltip' }">
      { this.message }
    </div>

    <yield />
  </div>

  <script>
    // set value
    this.value     = opts.value || opts.dataValue;
    this.message   = '';
    this.validated = opts.validated || this.value || false;

    // set date logic
    this.days   = [];
    this.years  = [];
    this.months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    // add days
    for (let i = 1; i <= 31; i++) {
      // add to days
      this.days.push(i);
    }

    // add years
    for (let i = (new Date()).getFullYear(); i >= ((new Date()).getFullYear() - 80); i--) {
      // add to years
      this.years.push(i);
    }

    /**
     * value
     *
     * @return {*}
     */
    val (value) {
      // return value
      if (!value) return this.value;

      // set value
      jQuery('input, select', this.root).val(value);
    }

    /**
     * returns if valid
     *
     * @return {*}
     */
    isValid () {
      // check validated
      if (!this.validated) return null;

      // check required
      if (opts.required && !(this.value || '').length) {
        // set message
        this.message = 'This field is required';

        // return false
        return false;
      }

      // check length
      if (opts.minLength && (this.value || '').length < parseInt(opts.minLength)) {
        // set message
        this.message = 'Please make sure you use at least ' + opts.minLength + ' characters';

        // return false
        return false;
      }

      // check length
      if (opts.maxLength && (this.value || '').length > parseInt(opts.maxLength)) {
        // set message
        this.message = 'Please make sure you use less than ' + opts.maxLength + ' characters';

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
      this.value = ['checkbox'].includes(opts.type) ? (jQuery(e.target).is(':checked') ? jQuery(e.target).val() : null) : e.target.value;

      // set validated
      this.validated = true;

      // proxy change function
      if (opts.onChange) opts.onChange(e);

      // trigger update
      this.trigger('update');
    }

    /**
     * on change
     *
     * @param  {Event} e
     *
     * @return {*}
     */
    onKeyup (e) {
      // set value
      this.value = e.target.value;

      // proxy change function
      if (opts.onKeyup) opts.onKeyup(e);

      // trigger update
      this.trigger('update');
    }

    /**
     * on day
     *
     * @param  {Event} e
     *
     * @return {*}
     */
    onDate (e) {
      // set birthday
      const birthday = new Date();

      // set year
      birthday.setYear(jQuery(this.refs.year).val());
      birthday.setMonth(this.months.map((item) => item.toLowerCase()).indexOf(jQuery(this.refs.month).val().toLowerCase()));
      birthday.setDate(jQuery(this.refs.day).val());

      console.log(jQuery(this.refs.day).val(), this.months.map((item) => item.toLowerCase()).indexOf(jQuery(this.refs.month).val().toLowerCase()), jQuery(this.refs.year).val());

      // set value
      this.value = birthday.toISOString();

      // set target
      let faux = Object.assign({}, e);

      // set value
      this.refs.date.value = this.value;

      // set target
      faux.target = this.refs.date;

      // set change
      this.onChange(faux);
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
