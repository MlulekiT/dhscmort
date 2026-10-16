*! dhscmort: DHS mortality rate tabulation, indicators and charts
*! Version 0.0.5, 2026
*! Author: Mluleki Tsawe

program define dhscmort
    version 15

    syntax anything [if] [in], ///
        [by(varname) ///
         period(integer 5) ///
         graph(string) ///
         angle(integer 0) ///
         legplace(string) ///
         title(string) ///
         name(string) ///
         export(string) ///
         scheme(string)]

    marksample touse
    local target = upper("`anything'")

    *---------------------------------------------*
    * Validate graph type
    *---------------------------------------------*
    if "`graph'" != "" {
        if !inlist("`graph'", "bar", "hbar") {
            di as error "graph() must be bar or hbar"
            exit 198
        }
    }

    *---------------------------------------------*
    * Validate indicator
    *---------------------------------------------*
    if !inlist("`target'", ///
        "INDICATORS", ///
        "NNMR", ///
        "PNNMR", ///
        "IMR", ///
        "CMR", ///
        "U5MR") {

        di as error ///
        "indicator must be indicators, NNMR, PNNMR, IMR, CMR, or U5MR"
        exit 198
    }

    *---------------------------------------------*
    * Capture by() variable label
    *---------------------------------------------*
    if "`by'" != "" {
        local byvar "`by'"

        local cat_title : variable label `byvar'
        if "`cat_title'" == "" {
            local cat_title "`byvar'"
        }
    }

    quietly {

        *---------------------------------------------*
        * Period setup
        *---------------------------------------------*
        local p_idx = (`period' / 5) - 1

        tempvar t1 t2

        gen `t2' = v008 - (60 * `p_idx')
        gen `t1' = `t2' - 60

        *---------------------------------------------*
        * Binary mortality variables
        *---------------------------------------------*
        capture drop ///
            mrt_nnmr ///
            mrt_pnnmr ///
            mrt_imr ///
            mrt_cmr ///
            mrt_u5mr

        gen mrt_nnmr = ///
            (b7 >= 0 & b7 < 1 & ///
            b3 >= `t1' & b3 < `t2') ///
            if b3 >= `t1' & b3 < `t2'

        gen mrt_pnnmr = ///
            (b7 >= 1 & b7 < 12 & ///
            b3 >= `t1' & b3 < `t2') ///
            if b3 >= `t1' & b3 < `t2'

        gen mrt_imr = ///
            (b7 >= 0 & b7 < 12 & ///
            b3 >= `t1' & b3 < `t2') ///
            if b3 >= `t1' & b3 < `t2'

        gen mrt_cmr = ///
            (b7 >= 12 & b7 < 60 & ///
            b3 >= `t1' & b3 < `t2') ///
            if b3 >= `t1' & b3 < `t2'

        gen mrt_u5mr = ///
            (b7 >= 0 & b7 < 60 & ///
            b3 >= `t1' & b3 < `t2') ///
            if b3 >= `t1' & b3 < `t2'

        preserve
        keep if `touse'

        *---------------------------------------------*
        * Synthetic cohort setup
        *---------------------------------------------*
        local f = cond(`p_idx' == 0, 1.0, 0.5)

        local agegroups 0 1 3 6 12 24 36 48 60

        tokenize `agegroups'

        foreach age of numlist `agegroups' {

            if (`age' < 60) {

                local a1 = `age'
                local a2 = `2'

                tempvar nA nB nC dA dB dC

                gen `nA' = ///
                    ((`a1' <= b7 & b7 < `a2') & ///
                    (`t1' - `a2' <= b3 & ///
                    b3 < `t1' - `a1'))

                gen `nB' = ///
                    ((`a1' <= b7 & b7 < `a2') & ///
                    (`t1' - `a1' <= b3 & ///
                    b3 < `t2' - `a2'))

                gen `nC' = ///
                    ((`a1' <= b7 & b7 < `a2') & ///
                    (`t2' - `a2' <= b3 & ///
                    b3 < `t2' - `a1'))

                gen `dA' = ///
                    ((b5 == 1 | `a1' <= b7) & ///
                    (`t1' - `a2' <= b3 & ///
                    b3 < `t1' - `a1'))

                gen `dB' = ///
                    ((b5 == 1 | `a1' <= b7) & ///
                    (`t1' - `a1' <= b3 & ///
                    b3 < `t2' - `a2'))

                gen `dC' = ///
                    ((b5 == 1 | `a1' <= b7) & ///
                    (`t2' - `a2' <= b3 & ///
                    b3 < `t2' - `a1'))

                gen num`age' = ///
                    0.5*`nA' + `nB' + `f'*`nC'

                gen den`age' = ///
                    0.5*`dA' + `dB' + 0.5*`dC'

                mac shift
            }
        }

        tempfile working_data
        save `working_data'

        tempfile master_results
        local first_pass 1

        local loop_list "`byvar' all"

        foreach g in `loop_list' {

            use `working_data', clear

            if "`g'" == "all" {

                gen Category = "Total"
                gen sort_order = 999999
                gen is_total = 1
            }
            else {

                gen sort_order = `byvar'
                gen is_total = 0

                capture decode `byvar', gen(Category)

                *---------------------------------------------*
                * Numeric variables without labels
                *---------------------------------------------*
                if _rc {
                    tostring `byvar', ///
                        gen(Category) ///
                        format(%18.0g)
                }
            }

            collapse ///
                (sum) num* den* ///
                (first) Category is_total ///
                [pw=v005/1000000], ///
                by(sort_order)

            gen i_id = _n

            reshape long num den, ///
                i(i_id) j(a1)

            sort i_id a1

            tempvar ///
                a2 ///
                death ///
                surv ///
                psurv ///
                psurv2

            by i_id: ///
                gen `a2' = a1[_n+1]

            by i_id: ///
                replace `a2' = 60 if a1 == 48

            gen `death' = num / den

            gen `surv' = 1 - `death'

            by i_id: ///
                gen `psurv' = `surv' ///
                if a1 == 0

            by i_id: ///
                replace `psurv' = ///
                `surv' * `psurv'[_n-1] ///
                if a1 > 0

            by i_id: ///
                gen `psurv2' = `surv' ///
                if a1 == 12

            by i_id: ///
                replace `psurv2' = ///
                `surv' * `psurv2'[_n-1] ///
                if a1 > 12

            gen NNMR = ///
                1000*(1-`psurv') ///
                if `a2' == 1

            gen IMR = ///
                1000*(1-`psurv') ///
                if `a2' == 12

            gen CMR = ///
                1000*(1-`psurv2') ///
                if `a2' == 60

            gen U5MR = ///
                1000*(1-`psurv') ///
                if `a2' == 60

            collapse ///
                (max) NNMR IMR CMR U5MR ///
                (first) Category is_total, ///
                by(sort_order)

            gen PNNMR = IMR - NNMR

            if `first_pass' == 1 {

                save `master_results', replace
                local first_pass 0
            }
            else {

                append using `master_results'
                save `master_results', replace
            }
        }

        use `master_results', clear

        sort sort_order

        *---------------------------------------------*
        * Dynamic y-axis ceiling
        *---------------------------------------------*
        if "`target'" == "INDICATORS" {

            tempvar maxval

            egen `maxval' = ///
                rowmax(NNMR PNNMR IMR CMR U5MR)

            summarize `maxval' ///
                if is_total == 0

            local ymax = r(max)
        }
        else {

            summarize `target' ///
                if is_total == 0

            local ymax = r(max)
        }

        local y_ceiling = ///
            ceil(`ymax'/10)*10

        if mod(`ymax',10)==0 {
            local y_ceiling = `ymax'
        }
    }

    *---------------------------------------------*
    * Labels and plot variables
    *---------------------------------------------*
    local label_p = ///
        cond(`period'==5, "0-4", ///
        cond(`period'==10, "5-9", ///
        cond(`period'==15, "10-14", ///
        "`period'")))

    local plotvars = ///
        cond("`target'"=="INDICATORS", ///
        "NNMR PNNMR IMR CMR U5MR", ///
        "`target'")

    *---------------------------------------------*
    * Graphs
    *---------------------------------------------*
    if "`graph'" != "" {

        local lopts = ///
            cond("`legplace'"=="inside", ///
            "ring(0) pos(1) cols(1) region(lcolor(black)) size(1.8)", ///
            "ring(1) pos(6) rows(1) size(1.8)")

        local gtitle = ///
            cond(`"`title'"'!="", ///
            `"title("`title'", size(2.5))"', "")

        local gscheme = ///
            cond("`scheme'"!="", ///
            "scheme(`scheme')", "")

        local i = 1

        foreach v in `plotvars' {

            local leglbl ///
                `leglbl' ///
                label(`i' "`v'")

            local i = `i' + 1
        }

        *---------------------------------------------*
        * Horizontal Bar Chart
        *---------------------------------------------*
        if "`graph'" == "hbar" {

            graph hbar (asis) ///
                `plotvars' ///
                if is_total == 0, ///
                over(Category, ///
                label(labsize(2)) ///
                sort(sort_order)) ///
                blabel(bar, ///
                format(%9.1f) ///
                size(tiny)) ///
                bargap(15) ///
                ytitle("Mortality rate", ///
                size(2.2)) ///
                l1title("`cat_title'", ///
                size(2.2)) ///
                ylabel(0(10)`y_ceiling', ///
                labsize(2) grid) ///
                `gtitle' ///
                legend(`leglbl' `lopts') ///
                `gscheme' ///
                name(`name', replace)
        }

        *---------------------------------------------*
        * Vertical Bar Chart
        *---------------------------------------------*
        else if "`graph'" == "bar" {

            graph bar (asis) ///
                `plotvars' ///
                if is_total == 0, ///
                over(Category, ///
                label(angle(`angle') ///
                labsize(2)) ///
                sort(sort_order)) ///
                blabel(bar, ///
                format(%9.1f) ///
                size(tiny)) ///
                bargap(15) ///
                ytitle("Mortality rate", ///
                size(2.2)) ///
                b1title("`cat_title'", ///
                size(2.2)) ///
                ylabel(0(10)`y_ceiling', ///
                labsize(2) grid) ///
                `gtitle' ///
                legend(`leglbl' `lopts') ///
                `gscheme' ///
                name(`name', replace)
        }

        *---------------------------------------------*
        * Export Graph
        *---------------------------------------------*
        if "`export'" != "" {

            local ext = ///
                lower(substr("`export'", ///
                strrpos("`export'", ".")+1, .))

            if inlist("`ext'", ///
                "png","jpg","jpeg","tif","tiff") {

                graph export ///
                    "`export'", ///
                    width(3500) replace
            }
            else {

                graph export ///
                    "`export'", replace
            }
        }
    }

    *---------------------------------------------*
    * Table Output
    *---------------------------------------------*
    if "`graph'" == "" {

        di _n as text ///
            "dhscmort `target' (Years: `label_p')"

        foreach v in ///
            NNMR ///
            PNNMR ///
            IMR ///
            CMR ///
            U5MR {

            capture format `v' %12.5f
        }

        list ///
            Category ///
            `plotvars', ///
            noobs ///
            separator(0) ///
            divider
    }

    restore
end